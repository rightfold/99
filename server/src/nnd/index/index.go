package index

import (
	"database/sql"
	"nnd/event"

	_ "github.com/lib/pq"
	"github.com/lib/pq/hstore"
)

// Index is safe for concurrent use by multiple goroutines.
type Index struct {
	db *sql.DB
}

// New creates a new index, and will run database schema migrations if
// necessary.
func New(db *sql.DB) (*Index, error) {
	_, err := db.Exec(setupScript)
	return &Index{db: db}, err
}

// Record records an event in the index.
func (i *Index) Record(event *event.Event) error {
	_, err := i.db.Exec(
		`
      INSERT INTO events (id, log, timestamp, host, level, fields)
      VALUES (uuid_generate_v4(), $1, $2, $3, $4, $5)
    `,
		event.Log,
		event.Timestamp,
		event.Host,
		int(event.Level),
		makeHstore(event.Fields),
	)
	return err
}

func makeHstore(xs map[string]string) *hstore.Hstore {
	hstore := &hstore.Hstore{Map: make(map[string]sql.NullString, len(xs))}
	for k, v := range xs {
		hstore.Map[k] = sql.NullString{String: v, Valid: true}
	}
	return hstore
}
