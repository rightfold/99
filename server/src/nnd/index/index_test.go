package index

import (
	"database/sql"
	"nnd/event"
	"os/exec"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestIndex(t *testing.T) {
	assert.Nil(t, exec.Command("dropdb", "-U", "postgres", "--if-exists", "99_nnd_index_test").Run())
	assert.Nil(t, exec.Command("createdb", "-U", "postgres", "99_nnd_index_test").Run())

	db, err := sql.Open("postgres", "user=postgres dbname=99_nnd_index_test sslmode=disable")
	assert.Nil(t, err)

	index, err := New(db)
	assert.Nil(t, err)

	events := []*event.Event{
		{Log: "", Timestamp: time.Now(), Host: "", Level: event.DEBUG, Fields: nil},
		{Log: "foo", Timestamp: time.Now(), Host: "localhost", Level: event.INFO, Fields: nil},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.NOTICE, Fields: nil},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.WARNING, Fields: map[string]string{}},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.ERROR, Fields: map[string]string{"k1": "v1"}},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.CRITICAL, Fields: map[string]string{"k1": "v1", "k2": "v2"}},
		{Log: "øµG", Timestamp: time.Now(), Host: "127.0.0.1", Level: event.ALERT, Fields: map[string]string{"k1": "v1", "k2": "v1"}},
	}
	for i, event := range events {
		err = index.Record(event)
		assert.Nil(t, err)
		var n int
		err = db.QueryRow(`SELECT count(*) FROM events`).Scan(&n)
		assert.Nil(t, err)
		assert.Equal(t, n, i+1)
	}
}
