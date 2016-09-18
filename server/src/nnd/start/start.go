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

func Start(handler []func(*context.Context, *event.Event) error) {
	if len(os.Args) != 2 {
		logrus.Fatal("bad usage")
	}

	events := make(chan *event.Event, eventsBufSize)
	go startFunnel(os.Args[1], events)
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
