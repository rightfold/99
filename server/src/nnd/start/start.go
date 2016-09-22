package start

import (
	"database/sql"
	"net"
	"net/http"
	"nnd/context"
	"nnd/event"
	"nnd/funnel"
	"nnd/index"
	"os"

	"github.com/Sirupsen/logrus"
)

const eventsBufSize = 1024

func Start(handlers []func(*context.Context, *event.Event) error) {
	if len(os.Args) != 2 {
		logrus.Fatal("bad usage")
	}

	events := make(chan *event.Event, eventsBufSize)

	indexDB, _ := sql.Open("postgres", "dbname=99_index user=postgres sslmode=disable")
	index, err := index.New(indexDB)
	if err != nil {
		logrus.WithField("err", err).Fatal("index setup")
	}

	go startFunnel(os.Args[1], events)
	go startHandlers(handlers, events)
	go startAPI(index)
	select {}
}

func startFunnel(addr string, events chan<- *event.Event) {
	network, addr := "tcp", addr
	logrus.WithField("net", network).WithField("addr", addr).Info("funnel boot")
	funnelListener, err := net.Listen(network, addr)
	if err != nil {
		logrus.WithField("err", err).Fatal("funnel boot failure")
	}
	err = funnel.ServeAll(funnelListener, events)
	logrus.WithField("err", err).Fatal("funnel failure")
}

func startHandlers(handlers []func(*context.Context, *event.Event) error, events <-chan *event.Event) {
	for event := range events {
		for _, handler := range handlers {
			err := handler(nil, event)
			if err != nil {
				logrus.WithField("err", err).Error("handler error")
			}
		}
	}
}

func startAPI(idx *index.Index) {
	indexAPI := index.NewAPI(idx)
	http.ListenAndServe("localhost:2000", indexAPI)
}
