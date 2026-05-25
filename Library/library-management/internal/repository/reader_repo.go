package repository

import (
	"context"
	"errors"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"library-management/internal/models"
)

type ReaderRepo struct {
	db *pgxpool.Pool
}

func NewReaderRepo(db *pgxpool.Pool) *ReaderRepo {
	return &ReaderRepo{db: db}
}

func (r *ReaderRepo) Create(ctx context.Context, reader *models.Reader) (int, error) {
	var id int
	err := r.db.QueryRow(ctx, `
		INSERT INTO readers (category_id, library_id, first_name, last_name, registration_date)
		VALUES ($1, $2, $3, $4, $5) RETURNING id
	`, reader.CategoryID, reader.LibraryID, reader.FirstName, reader.LastName, reader.RegistrationDate).Scan(&id)
	if err != nil {
		return 0, err
	}
	return id, nil
}

func (r *ReaderRepo) GetByID(ctx context.Context, id int) (*models.Reader, error) {
	var reader models.Reader
	err := r.db.QueryRow(ctx, `
		SELECT r.id, r.category_id, r.library_id, r.first_name, r.last_name, r.registration_date,
		       rc.name as category_name, l.name as library_name
		FROM readers r
		JOIN reader_categories rc ON r.category_id = rc.id
		JOIN libraries l ON r.library_id = l.id
		WHERE r.id = $1
	`, id).Scan(
		&reader.ID, &reader.CategoryID, &reader.LibraryID, &reader.FirstName, &reader.LastName,
		&reader.RegistrationDate, &reader.CategoryName, &reader.LibraryName,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &reader, nil
}

func (r *ReaderRepo) Update(ctx context.Context, reader *models.Reader) error {
	_, err := r.db.Exec(ctx, `
		UPDATE readers SET category_id=$1, library_id=$2, first_name=$3, last_name=$4
		WHERE id=$5
	`, reader.CategoryID, reader.LibraryID, reader.FirstName, reader.LastName, reader.ID)
	return err
}

func (r *ReaderRepo) Delete(ctx context.Context, id int) error {
	_, err := r.db.Exec(ctx, `DELETE FROM readers WHERE id=$1`, id)
	return err
}

func (r *ReaderRepo) List(ctx context.Context, limit, offset int) ([]models.Reader, error) {
	rows, err := r.db.Query(ctx, `
		SELECT r.id, r.category_id, r.library_id, r.first_name, r.last_name, r.registration_date,
		       rc.name as category_name, l.name as library_name
		FROM readers r
		JOIN reader_categories rc ON r.category_id = rc.id
		JOIN libraries l ON r.library_id = l.id
		ORDER BY r.id
		LIMIT $1 OFFSET $2
	`, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var readers []models.Reader
	for rows.Next() {
		var r models.Reader
		err := rows.Scan(&r.ID, &r.CategoryID, &r.LibraryID, &r.FirstName, &r.LastName,
			&r.RegistrationDate, &r.CategoryName, &r.LibraryName)
		if err != nil {
			return nil, err
		}
		readers = append(readers, r)
	}
	return readers, nil
}

// Методы для работы с динамическими атрибутами
func (r *ReaderRepo) GetCategoryAttributes(ctx context.Context, categoryID int) ([]models.ReaderCategoryAttribute, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, category_id, name FROM reader_category_attributes WHERE category_id=$1
	`, categoryID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var attrs []models.ReaderCategoryAttribute
	for rows.Next() {
		var a models.ReaderCategoryAttribute
		if err := rows.Scan(&a.ID, &a.CategoryID, &a.Name); err != nil {
			return nil, err
		}
		attrs = append(attrs, a)
	}
	return attrs, nil
}

func (r *ReaderRepo) SetAttributeValue(ctx context.Context, val models.ReaderAttributeValue) error {
	_, err := r.db.Exec(ctx, `
		INSERT INTO reader_category_attribute_values (reader_id, category_id, attribute_id, value)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (reader_id, attribute_id) DO UPDATE SET value = EXCLUDED.value
	`, val.ReaderID, val.CategoryID, val.AttributeID, val.Value)
	return err
}

func (r *ReaderRepo) GetAttributeValues(ctx context.Context, readerID int) ([]models.ReaderAttributeValue, error) {
	rows, err := r.db.Query(ctx, `
		SELECT rcav.reader_id, rcav.category_id, rcav.attribute_id, rcav.value, rca.name
		FROM reader_category_attribute_values rcav
		JOIN reader_category_attributes rca ON rcav.attribute_id = rca.id
		WHERE rcav.reader_id = $1
	`, readerID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var values []models.ReaderAttributeValue
	for rows.Next() {
		var v models.ReaderAttributeValue
		err := rows.Scan(&v.ReaderID, &v.CategoryID, &v.AttributeID, &v.Value, &v.AttributeName)
		if err != nil {
			return nil, err
		}
		values = append(values, v)
	}
	return values, nil
}

// GetFreeReaderID возвращает ID читателя, который ещё не привязан к пользователю
func (r *ReaderRepo) GetFreeReaderID(ctx context.Context) (int, error) {
	var id int
	err := r.db.QueryRow(ctx, `
		SELECT id FROM readers 
		WHERE id NOT IN (SELECT reader_id FROM users WHERE reader_id IS NOT NULL)
		LIMIT 1
	`).Scan(&id)
	if err != nil {
		return 0, err
	}
	return id, nil
}

// GetAllCategories возвращает все категории читателей
func (r *ReaderRepo) GetAllCategories(ctx context.Context) ([]models.ReaderCategory, error) {
	rows, err := r.db.Query(ctx, "SELECT id, name FROM reader_categories ORDER BY name")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var categories []models.ReaderCategory
	for rows.Next() {
		var c models.ReaderCategory
		if err := rows.Scan(&c.ID, &c.Name); err != nil {
			return nil, err
		}
		categories = append(categories, c)
	}
	return categories, nil
}

// GetAllLibraries возвращает все библиотеки
func (r *ReaderRepo) GetAllLibraries(ctx context.Context) ([]models.Library, error) {
	rows, err := r.db.Query(ctx, "SELECT id, name FROM libraries ORDER BY name")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var libraries []models.Library
	for rows.Next() {
		var l models.Library
		if err := rows.Scan(&l.ID, &l.Name); err != nil {
			return nil, err
		}
		libraries = append(libraries, l)
	}
	return libraries, nil
}
