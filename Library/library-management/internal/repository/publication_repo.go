package repository

import (
	"context"
	"errors"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"library-management/internal/models"
	"strconv"
	"time"
)

type PublicationRepo struct {
	db *pgxpool.Pool
}

func NewPublicationRepo(db *pgxpool.Pool) *PublicationRepo {
	return &PublicationRepo{db: db}
}

// ---------- Публикации ----------
func (r *PublicationRepo) CreatePublication(ctx context.Context, pub *models.Publication) (int, error) {
	var id int
	err := r.db.QueryRow(ctx, `
		INSERT INTO publications (title, publish_date, publisher)
		VALUES ($1, $2, $3) RETURNING id
	`, pub.Title, pub.PublishDate, pub.Publisher).Scan(&id)
	return id, err
}

func (r *PublicationRepo) GetPublicationByID(ctx context.Context, id int) (*models.Publication, error) {
	var pub models.Publication
	err := r.db.QueryRow(ctx, `
		SELECT id, title, publish_date, publisher FROM publications WHERE id = $1
	`, id).Scan(&pub.ID, &pub.Title, &pub.PublishDate, &pub.Publisher)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &pub, err
}

func (r *PublicationRepo) ListPublications(ctx context.Context, limit, offset int) ([]models.Publication, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, title, publish_date, publisher FROM publications
		ORDER BY id LIMIT $1 OFFSET $2
	`, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var pubs []models.Publication
	for rows.Next() {
		var p models.Publication
		if err := rows.Scan(&p.ID, &p.Title, &p.PublishDate, &p.Publisher); err != nil {
			return nil, err
		}
		pubs = append(pubs, p)
	}
	return pubs, nil
}

// ---------- Экземпляры ----------
func (r *PublicationRepo) CreateCopy(ctx context.Context, copy *models.PublicationCopy) error {
	_, err := r.db.Exec(ctx, `
		INSERT INTO publications_copy (inventory_number, publication_id, shelf_id, receipt_date, received_employee_id)
		VALUES ($1, $2, $3, $4, $5)
	`, copy.InventoryNumber, copy.PublicationID, copy.ShelfID, copy.ReceiptDate, copy.ReceivedEmployeeID)
	return err
}

func (r *PublicationRepo) GetCopyByInventoryNumber(ctx context.Context, inv int) (*models.PublicationCopy, error) {
	var copy models.PublicationCopy
	err := r.db.QueryRow(ctx, `
		SELECT inventory_number, publication_id, shelf_id, receipt_date, received_employee_id
		FROM publications_copy WHERE inventory_number = $1
	`, inv).Scan(&copy.InventoryNumber, &copy.PublicationID, &copy.ShelfID, &copy.ReceiptDate, &copy.ReceivedEmployeeID)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &copy, err
}

// ---------- Правила выдачи ----------
func (r *PublicationRepo) GetPublicationRules(ctx context.Context, publicationID int) (*models.PublicationRule, error) {
	var rule models.PublicationRule
	err := r.db.QueryRow(ctx, `
		SELECT publication_id, reading_room_only, loan_period_days
		FROM publication_rules WHERE publication_id = $1
	`, publicationID).Scan(&rule.PublicationID, &rule.ReadingRoomOnly, &rule.LoanPeriodDays)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, nil
	}
	return &rule, err
}

func (r *PublicationRepo) SetPublicationRules(ctx context.Context, rule *models.PublicationRule) error {
	_, err := r.db.Exec(ctx, `
		INSERT INTO publication_rules (publication_id, reading_room_only, loan_period_days)
		VALUES ($1, $2, $3)
		ON CONFLICT (publication_id) DO UPDATE
		SET reading_room_only = EXCLUDED.reading_room_only, loan_period_days = EXCLUDED.loan_period_days
	`, rule.PublicationID, rule.ReadingRoomOnly, rule.LoanPeriodDays)
	return err
}

// UpdatePublication обновляет данные публикации
func (r *PublicationRepo) UpdatePublication(ctx context.Context, pub *models.Publication) error {
	_, err := r.db.Exec(ctx,
		`UPDATE publications SET title=$1, publish_date=$2, publisher=$3 WHERE id=$4`,
		pub.Title, pub.PublishDate, pub.Publisher, pub.ID)
	return err
}

// DeletePublication удаляет публикацию
func (r *PublicationRepo) DeletePublication(ctx context.Context, id int) error {
	_, err := r.db.Exec(ctx, `DELETE FROM publications WHERE id=$1`, id)
	return err
}

// UpdateCopy обновляет местоположение экземпляра
func (r *PublicationRepo) UpdateCopy(ctx context.Context, inv int, shelfID, receivedEmployeeID int) error {
	_, err := r.db.Exec(ctx,
		`UPDATE publications_copy SET shelf_id=$1, received_employee_id=$2 WHERE inventory_number=$3`,
		shelfID, receivedEmployeeID, inv)
	return err
}

// DeleteCopy удаляет экземпляр (без проверок)
func (r *PublicationRepo) DeleteCopy(ctx context.Context, inv int) error {
	_, err := r.db.Exec(ctx, `DELETE FROM publications_copy WHERE inventory_number=$1`, inv)
	return err
}

// WriteOffCopy списывает экземпляр
func (r *PublicationRepo) WriteOffCopy(ctx context.Context, inv int, employeeID int) error {
	var pubID int
	err := r.db.QueryRow(ctx, `SELECT publication_id FROM publications_copy WHERE inventory_number=$1`, inv).Scan(&pubID)
	if err != nil {
		return err
	}
	_, err = r.db.Exec(ctx,
		`INSERT INTO written_off (inventory_number, publication_id, write_off_date, write_off_employee_id)
		 VALUES ($1, $2, $3, $4)`,
		strconv.Itoa(inv), pubID, time.Now(), employeeID)
	return err
}

// HasActiveLoans проверяет, есть ли активные выдачи у экземпляра
func (r *PublicationRepo) HasActiveLoans(ctx context.Context, inv int) (bool, error) {
	var active bool
	err := r.db.QueryRow(ctx,
		`SELECT EXISTS(SELECT 1 FROM loans WHERE copy_inventory_number=$1 AND return_date IS NULL)`, inv).Scan(&active)
	return active, err
}
