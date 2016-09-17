package funnel

import (
	"encoding/json"
	"nnd/event"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestOK(t *testing.T) {
	events := []*event.Event{
		{Log: "", Timestamp: time.Now(), Host: "", Level: event.DEBUG, Fields: nil},
		{Log: "foo", Timestamp: time.Now(), Host: "localhost", Level: event.INFO, Fields: nil},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.NOTICE, Fields: nil},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.WARNING, Fields: map[string]string{}},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.ERROR, Fields: map[string]string{"k1": "v1"}},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.CRITICAL, Fields: map[string]string{"k1": "v1", "k2": "v2"}},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.ALERT, Fields: map[string]string{"k1": "v1", "k2": "v1"}},
	}
	for _, original := range events {
		json, err := json.Marshal(original)
		assert.Nil(t, err)

		new, err := Parse([]byte(json))
		assert.Nil(t, err)

		assert.Equal(t, new.Log, original.Log)
		assert.True(t, new.Timestamp.Equal(original.Timestamp))
		assert.Equal(t, new.Host, original.Host)
		assert.Equal(t, new.Level, original.Level)
		assert.Equal(t, new.Fields, original.Fields)
	}
}

func TestBadLevel(t *testing.T) {
	var err error

	_, err = Parse([]byte(`{"Level": 0}`))
	if err != ErrBadLevel {
		t.Errorf("got no or wrong error: %s", err)
	}

	_, err = Parse([]byte(`{"Level": 8}`))
	if err != ErrBadLevel {
		t.Errorf("got no or wrong error: %s", err)
	}
}
