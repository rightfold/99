package start

import (
	"net"
	"nnd/context"
	"nnd/event"
	"nnd/funnel"
	"os"

	"github.com/Sirupsen/logrus"
)

const eventsBufSize = 1024

func Start(handlers []func(*context.Context, *event.Event) error) {
	if len(os.Args) != 2 {
		logrus.Fatal("bad usage")
	}

	events := make(chan *event.Event, eventsBufSize)
	go startFunnel(os.Args[1], events)
	go startHandlers(handlers, events)
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
			go handler(nil, event)
		}
	}
}
