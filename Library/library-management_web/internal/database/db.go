package database

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5/pgxpool"
	"library-management/internal/config"
)

type DB struct {
	Pool *pgxpool.Pool
}

func New(cfg *config.Config) (*DB, error) {
	connString := cfg.GetDBConnString()
	pool, err := pgxpool.New(context.Background(), connString)
	if err != nil {
		return nil, err
	}
	if err = pool.Ping(context.Background()); err != nil {
		return nil, err
	}
	log.Println("Database connected")
	return &DB{Pool: pool}, nil
}

func (db *DB) Close() {
	if db.Pool != nil {
		db.Pool.Close()
	}
}
