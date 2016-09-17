package funnel

import (
	"encoding/binary"
	"io"
	"net"
	"nnd/event"

	"github.com/Sirupsen/logrus"
)

// ServeAll accepts all incoming connections and serves them.
func ServeAll(listener net.Listener, events chan<- *event.Event) error {
	defer listener.Close()
	for {
		client, err := listener.Accept()
		if err != nil {
			logrus.WithField("err", err).Error("funnel accept failure")
			return err
		}
		logrus.WithField("addr", client.RemoteAddr()).Info("funnel accept")
		go Serve(client, events)
	}
}

// Serve serves a single connection.
func Serve(conn net.Conn, events chan<- *event.Event) error {
	defer conn.Close()
	for {
		var (
			err        error
			packetLen  uint16
			packetData []byte
		)

		err = binary.Read(conn, binary.BigEndian, &packetLen)
		if err != nil {
			logrus.WithField("err", err).Error("funnel length failure")
			return err
		}

		packetData = make([]byte, packetLen)
		_, err = io.ReadFull(conn, packetData)
		if err != nil {
			logrus.WithField("err", err).Error("funnel data failure")
			return err
		}

		event, err := Parse(packetData)
		if err != nil {
			logrus.WithField("err", err).Error("funnel event failure")
			return err
		}
		logrus.WithField("event", event).Info("funnel event")
		events <- event
	}
}
