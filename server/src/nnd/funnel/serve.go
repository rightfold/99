package funnel

import (
	"encoding/binary"
	"io"
	"net"
	"nnd/event"
)

// ServeAll accepts all incoming connections and serves them.
func ServeAll(listener net.Listener, events chan<- *event.Event) error {
	defer listener.Close()
	for {
		client, err := listener.Accept()
		if err != nil {
			return err
		}
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
			return err
		}

		packetData = make([]byte, packetLen)
		_, err = io.ReadFull(conn, packetData)
		if err != nil {
			return err
		}

		event, err := Parse(packetData)
		if err != nil {
			return err
		}
		events <- event
	}
}
