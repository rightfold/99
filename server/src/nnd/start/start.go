package start

import (
	"net"
	"nnd/event"
	"nnd/funnel"

	"github.com/Sirupsen/logrus"
)

const eventsBufSize = 1024

func Start(handler []func(*event.Event) error) {
	events := make(chan *event.Event, eventsBufSize)
	go startFunnel(events)
	select {}
}

func startFunnel(events chan<- *event.Event) {
	network, addr := "tcp", "0.0.0.0:1337"
	logrus.WithField("net", network).WithField("addr", addr).Info("funnel boot")
	funnelListener, err := net.Listen(network, addr)
	if err != nil {
		logrus.WithField("err", err).Fatal("funnel boot failure")
	}
	err = funnel.ServeAll(funnelListener, events)
	logrus.WithField("err", err).Fatal("funnel failure")
}
