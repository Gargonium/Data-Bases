package repository

import (
	"context"
	"github.com/jackc/pgx/v5/pgxpool"
	"time"
)

type QueryRepo struct {
	db *pgxpool.Pool
}

func NewQueryRepo(db *pgxpool.Pool) *QueryRepo {
	return &QueryRepo{db: db}
}

// 1. Читатель с характеристиками (показываем ФИО, категорию, библиотеку, атрибуты)
type ReaderWithAttributes struct {
	FirstName      string `json:"first_name"`
	LastName       string `json:"last_name"`
	Category       string `json:"category"`
	Library        string `json:"library"`
	AttributeName  string `json:"attribute_name"`
	AttributeValue string `json:"attribute_value"`
}

// 2. Читатель с указанным произведением на руках
type ReaderWithWork struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	WorkTitle string `json:"work_title"`
}

// 3. Читатель с указанным изданием на руках
type ReaderWithPublication struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	PubTitle  string `json:"publication_title"`
}

// 4. Читатели, получавшие издание с произведением за период + название издания
type ReaderWithPublicationPeriod struct {
	FirstName string    `json:"first_name"`
	LastName  string    `json:"last_name"`
	PubTitle  string    `json:"publication_title"`
	IssueDate time.Time `json:"issue_date"`
}

// 5. Издания, которые получал читатель из своей библиотеки за период
type PublicationFromOwnLibrary struct {
	Title       string    `json:"title"`
	PublishDate time.Time `json:"publish_date"`
	Publisher   string    `json:"publisher"`
	IssueDate   time.Time `json:"issue_date"`
}

// 6. Издания, которыми пользовался читатель из чужой библиотеки (читальный зал)
type PublicationFromOtherLibrary struct {
	Title       string    `json:"title"`
	PublishDate time.Time `json:"publish_date"`
	Publisher   string    `json:"publisher"`
	LibraryName string    `json:"library_name"`
	ReadingDate time.Time `json:"reading_date"`
}

// 7. Литература, выданная с определённой полки в данный момент
type PublicationFromShelf struct {
	Title           string    `json:"title"`
	InventoryNumber int       `json:"inventory_number"`
	ShelfID         int       `json:"shelf_id"` // shelf id нужен для идентификации полки, но по требованию "без id" – можно убрать, оставив название полки. Пока оставим ID, т.к. полка может быть не именована. Можно добавить номер стеллажа.
	DueDate         time.Time `json:"due_date"`
}

// 8. Читатели, обслуженные библиотекарем за период
type ReaderServedByEmployee struct {
	FirstName    string    `json:"first_name"`
	LastName     string    `json:"last_name"`
	EmployeeName string    `json:"employee_name"`
	IssueDate    time.Time `json:"issue_date"`
}

// 9. Выработка библиотекарей (число обслуженных читателей за период)
type EmployeeWorkload struct {
	EmployeeName  string `json:"employee_name"`
	ReadersServed int    `json:"readers_served"`
}

// 10. Читатели с просроченной литературой
type ReaderWithOverdue struct {
	FirstName        string    `json:"first_name"`
	LastName         string    `json:"last_name"`
	PublicationTitle string    `json:"publication_title"`
	ExpireDate       time.Time `json:"expire_date"`
}

// 11. Литература, поступившая/списанная за период
type CopyMovement struct {
	InventoryNumber  int       `json:"inventory_number"`
	PublicationTitle string    `json:"publication_title"`
	EventDate        time.Time `json:"event_date"`
	EventType        string    `json:"event_type"` // 'received' or 'written_off'
}

// 12. Библиотекари, работающие в указанном читальном зале
type EmployeeInReadingRoom struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}

// 13. Читатели, не посещавшие библиотеку за период
type InactiveReader struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Library   string `json:"library"`
}

// 14. Инвентарные номера и названия изданий, содержащих указанное произведение
type CopyWithWork struct {
	InventoryNumber  int    `json:"inventory_number"`
	PublicationTitle string `json:"publication_title"`
	WorkTitle        string `json:"work_title"`
}

// 15. Инвентарные номера и названия изданий, содержащих произведения указанного автора
type CopyWithAuthor struct {
	InventoryNumber  int    `json:"inventory_number"`
	PublicationTitle string `json:"publication_title"`
	AuthorName       string `json:"author_name"`
}

// 16. Самые популярные произведения (топ-3)
type PopularWork struct {
	WorkTitle  string `json:"work_title"`
	UsageCount int    `json:"usage_count"`
}

// 1. Читатели с заданными характеристиками (один атрибут)
func (q *QueryRepo) GetReadersByAttribute(ctx context.Context, categoryID int, attrName, attrValue string) ([]ReaderWithAttributes, error) {
	rows, err := q.db.Query(ctx, `
		SELECT r.first_name, r.last_name, rc.name AS category, l.name AS library,
		       rca.name AS attribute_name, rcav.value AS attribute_value
		FROM readers r
		JOIN reader_categories rc ON r.category_id = rc.id
		JOIN libraries l ON r.library_id = l.id
		JOIN reader_category_attribute_values rcav ON r.id = rcav.reader_id
		JOIN reader_category_attributes rca ON rcav.attribute_id = rca.id
		WHERE r.category_id = $1 AND rca.name = $2 AND rcav.value = $3
	`, categoryID, attrName, attrValue)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var result []ReaderWithAttributes
	for rows.Next() {
		var r ReaderWithAttributes
		err := rows.Scan(&r.FirstName, &r.LastName, &r.Category, &r.Library, &r.AttributeName, &r.AttributeValue)
		if err != nil {
			return nil, err
		}
		result = append(result, r)
	}
	return result, nil
}

// 2. Читатели, у которых указанное произведение на руках
func (q *QueryRepo) GetReadersByWorkOnHands(ctx context.Context, workID int) ([]ReaderWithWork, error) {
	rows, err := q.db.Query(ctx, `
		SELECT DISTINCT r.first_name, r.last_name, w.title AS work_title
		FROM readers r
		JOIN loans l ON r.id = l.reader_id
		JOIN publications_copy pc ON l.copy_inventory_number = pc.inventory_number
		JOIN publications_works pw ON pc.publication_id = pw.publication_id
		JOIN works w ON pw.work_id = w.id
		WHERE w.id = $1 AND l.return_date IS NULL
	`, workID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []ReaderWithWork
	for rows.Next() {
		var rw ReaderWithWork
		if err := rows.Scan(&rw.FirstName, &rw.LastName, &rw.WorkTitle); err != nil {
			return nil, err
		}
		res = append(res, rw)
	}
	return res, nil
}

// 3. Читатели, у которых указанное издание на руках
func (q *QueryRepo) GetReadersByPublicationOnHands(ctx context.Context, publicationID int) ([]ReaderWithPublication, error) {
	rows, err := q.db.Query(ctx, `
		SELECT r.first_name, r.last_name, p.title
		FROM readers r
		JOIN loans l ON r.id = l.reader_id
		JOIN publications_copy pc ON l.copy_inventory_number = pc.inventory_number
		JOIN publications p ON pc.publication_id = p.id
		WHERE p.id = $1 AND l.return_date IS NULL
	`, publicationID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []ReaderWithPublication
	for rows.Next() {
		var rp ReaderWithPublication
		if err := rows.Scan(&rp.FirstName, &rp.LastName, &rp.PubTitle); err != nil {
			return nil, err
		}
		res = append(res, rp)
	}
	return res, nil
}

// 4. Читатели, получавшие издание с произведением за период (и название издания)
func (q *QueryRepo) GetReadersByWorkInPeriod(ctx context.Context, workID int, dateFrom, dateTo time.Time) ([]ReaderWithPublicationPeriod, error) {
	rows, err := q.db.Query(ctx, `
		SELECT DISTINCT r.first_name, r.last_name, p.title, l.date_of_issue
		FROM readers r
		JOIN loans l ON r.id = l.reader_id
		JOIN publications_copy pc ON l.copy_inventory_number = pc.inventory_number
		JOIN publications p ON pc.publication_id = p.id
		JOIN publications_works pw ON p.id = pw.publication_id
		WHERE pw.work_id = $1 AND l.date_of_issue BETWEEN $2 AND $3
	`, workID, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []ReaderWithPublicationPeriod
	for rows.Next() {
		var rpp ReaderWithPublicationPeriod
		if err := rows.Scan(&rpp.FirstName, &rpp.LastName, &rpp.PubTitle, &rpp.IssueDate); err != nil {
			return nil, err
		}
		res = append(res, rpp)
	}
	return res, nil
}

// 5. Издания, которые получал указанный читатель из фонда своей библиотеки за период
func (q *QueryRepo) GetPublicationsFromOwnLibrary(ctx context.Context, readerID int, dateFrom, dateTo time.Time) ([]PublicationFromOwnLibrary, error) {
	rows, err := q.db.Query(ctx, `
		SELECT DISTINCT p.title, p.publish_date, p.publisher, l.date_of_issue
		FROM loans l
		JOIN readers r ON l.reader_id = r.id
		JOIN publications_copy pc ON l.copy_inventory_number = pc.inventory_number
		JOIN publications p ON pc.publication_id = p.id
		WHERE r.id = $1 AND r.library_id = (SELECT library_id FROM readers WHERE id = $1)
		  AND l.date_of_issue BETWEEN $2 AND $3
	`, readerID, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []PublicationFromOwnLibrary
	for rows.Next() {
		var p PublicationFromOwnLibrary
		if err := rows.Scan(&p.Title, &p.PublishDate, &p.Publisher, &p.IssueDate); err != nil {
			return nil, err
		}
		res = append(res, p)
	}
	return res, nil
}

// 6. Издания, которыми пользовался читатель из фонда чужой библиотеки (читальный зал)
func (q *QueryRepo) GetPublicationsFromOtherLibrary(ctx context.Context, readerID int, dateFrom, dateTo time.Time) ([]PublicationFromOtherLibrary, error) {
	rows, err := q.db.Query(ctx, `
		SELECT DISTINCT p.title, p.publish_date, p.publisher, l.name AS library_name, rp.issued_date
		FROM reading_process rp
		JOIN readers r ON rp.reader_id = r.id
		JOIN publications_copy pc ON rp.copy_inventory_number = pc.inventory_number
		JOIN publications p ON pc.publication_id = p.id
		JOIN libraries l ON rp.library_id = l.id
		WHERE r.id = $1 AND rp.library_id <> r.library_id
		  AND rp.issued_date BETWEEN $2 AND $3
	`, readerID, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []PublicationFromOtherLibrary
	for rows.Next() {
		var po PublicationFromOtherLibrary
		if err := rows.Scan(&po.Title, &po.PublishDate, &po.Publisher, &po.LibraryName, &po.ReadingDate); err != nil {
			return nil, err
		}
		res = append(res, po)
	}
	return res, nil
}

// 7. Литература, выданная с определённой полки в настоящий момент
func (q *QueryRepo) GetLoanedFromShelf(ctx context.Context, shelfID int) ([]PublicationFromShelf, error) {
	rows, err := q.db.Query(ctx, `
		SELECT p.title, pc.inventory_number, pc.shelf_id, l.expire_date
		FROM publications_copy pc
		JOIN publications p ON pc.publication_id = p.id
		JOIN loans l ON pc.inventory_number = l.copy_inventory_number
		WHERE pc.shelf_id = $1 AND l.return_date IS NULL
	`, shelfID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []PublicationFromShelf
	for rows.Next() {
		var ps PublicationFromShelf
		if err := rows.Scan(&ps.Title, &ps.InventoryNumber, &ps.ShelfID, &ps.DueDate); err != nil {
			return nil, err
		}
		res = append(res, ps)
	}
	return res, nil
}

// 8. Читатели, обслуженные указанным библиотекарем за период
func (q *QueryRepo) GetReadersServedByEmployee(ctx context.Context, employeeID int, dateFrom, dateTo time.Time) ([]ReaderServedByEmployee, error) {
	rows, err := q.db.Query(ctx, `
		SELECT DISTINCT r.first_name, r.last_name, e.first_name || ' ' || e.last_name AS employee_name, l.date_of_issue
		FROM readers r
		JOIN loans l ON r.id = l.reader_id
		JOIN employee e ON l.issued_employee_id = e.id
		WHERE e.id = $1 AND l.date_of_issue BETWEEN $2 AND $3
	`, employeeID, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []ReaderServedByEmployee
	for rows.Next() {
		var rse ReaderServedByEmployee
		if err := rows.Scan(&rse.FirstName, &rse.LastName, &rse.EmployeeName, &rse.IssueDate); err != nil {
			return nil, err
		}
		res = append(res, rse)
	}
	return res, nil
}

// 9. Выработка библиотекарей за период
func (q *QueryRepo) GetEmployeeWorkload(ctx context.Context, dateFrom, dateTo time.Time) ([]EmployeeWorkload, error) {
	rows, err := q.db.Query(ctx, `
		SELECT e.first_name || ' ' || e.last_name AS employee_name, COUNT(l.reader_id) AS readers_served
		FROM employee e
		LEFT JOIN loans l ON e.id = l.issued_employee_id AND l.date_of_issue BETWEEN $1 AND $2
		GROUP BY e.id
	`, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []EmployeeWorkload
	for rows.Next() {
		var ew EmployeeWorkload
		if err := rows.Scan(&ew.EmployeeName, &ew.ReadersServed); err != nil {
			return nil, err
		}
		res = append(res, ew)
	}
	return res, nil
}

// 10. Читатели с просроченной литературой
func (q *QueryRepo) GetReadersWithOverdue(ctx context.Context) ([]ReaderWithOverdue, error) {
	rows, err := q.db.Query(ctx, `
		SELECT r.first_name, r.last_name, p.title, l.expire_date
		FROM readers r
		JOIN loans l ON r.id = l.reader_id
		JOIN publications_copy pc ON l.copy_inventory_number = pc.inventory_number
		JOIN publications p ON pc.publication_id = p.id
		WHERE l.expire_date < CURRENT_DATE AND l.return_date IS NULL
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []ReaderWithOverdue
	for rows.Next() {
		var rwo ReaderWithOverdue
		if err := rows.Scan(&rwo.FirstName, &rwo.LastName, &rwo.PublicationTitle, &rwo.ExpireDate); err != nil {
			return nil, err
		}
		res = append(res, rwo)
	}
	return res, nil
}

// 11. Литература, поступившая или списанная за период (два набора объединяем)
func (q *QueryRepo) GetCopyMovements(ctx context.Context, dateFrom, dateTo time.Time) ([]CopyMovement, error) {
	rows, err := q.db.Query(ctx, `
		SELECT pc.inventory_number, p.title, pc.receipt_date AS event_date, 'received' AS event_type
		FROM publications_copy pc
		JOIN publications p ON pc.publication_id = p.id
		WHERE pc.receipt_date BETWEEN $1 AND $2
		UNION ALL
		SELECT wo.inventory_number::int, p.title, wo.write_off_date, 'written_off'
		FROM written_off wo
		JOIN publications p ON wo.publication_id = p.id
		WHERE wo.write_off_date BETWEEN $1 AND $2
		ORDER BY event_date
	`, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []CopyMovement
	for rows.Next() {
		var cm CopyMovement
		if err := rows.Scan(&cm.InventoryNumber, &cm.PublicationTitle, &cm.EventDate, &cm.EventType); err != nil {
			return nil, err
		}
		res = append(res, cm)
	}
	return res, nil
}

// 12. Библиотекари, работающие в указанном читальном зале
func (q *QueryRepo) GetEmployeesByReadingRoom(ctx context.Context, libraryID, readingRoomID int) ([]EmployeeInReadingRoom, error) {
	rows, err := q.db.Query(ctx, `
		SELECT first_name, last_name
		FROM employee
		WHERE library_id = $1 AND reading_room_id = $2
	`, libraryID, readingRoomID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []EmployeeInReadingRoom
	for rows.Next() {
		var e EmployeeInReadingRoom
		if err := rows.Scan(&e.FirstName, &e.LastName); err != nil {
			return nil, err
		}
		res = append(res, e)
	}
	return res, nil
}

// 13. Читатели, не посещавшие библиотеку за период (ни loans, ни reading_process)
func (q *QueryRepo) GetInactiveReaders(ctx context.Context, dateFrom, dateTo time.Time) ([]InactiveReader, error) {
	rows, err := q.db.Query(ctx, `
		SELECT r.first_name, r.last_name, l.name AS library_name
		FROM readers r
		JOIN libraries l ON r.library_id = l.id
		WHERE r.id NOT IN (
			SELECT reader_id FROM loans WHERE date_of_issue BETWEEN $1 AND $2
			UNION
			SELECT reader_id FROM reading_process WHERE issued_date BETWEEN $1 AND $2
		)
	`, dateFrom, dateTo)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []InactiveReader
	for rows.Next() {
		var ir InactiveReader
		if err := rows.Scan(&ir.FirstName, &ir.LastName, &ir.Library); err != nil {
			return nil, err
		}
		res = append(res, ir)
	}
	return res, nil
}

// 14. Инвентарные номера и названия изданий, содержащих указанное произведение
func (q *QueryRepo) GetCopiesByWork(ctx context.Context, workID int) ([]CopyWithWork, error) {
	rows, err := q.db.Query(ctx, `
		SELECT pc.inventory_number, p.title, w.title AS work_title
		FROM publications_copy pc
		JOIN publications p ON pc.publication_id = p.id
		JOIN publications_works pw ON p.id = pw.publication_id
		JOIN works w ON pw.work_id = w.id
		WHERE w.id = $1
	`, workID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []CopyWithWork
	for rows.Next() {
		var cw CopyWithWork
		if err := rows.Scan(&cw.InventoryNumber, &cw.PublicationTitle, &cw.WorkTitle); err != nil {
			return nil, err
		}
		res = append(res, cw)
	}
	return res, nil
}

// 15. Инвентарные номера и названия изданий, содержащих произведения указанного автора
func (q *QueryRepo) GetCopiesByAuthor(ctx context.Context, authorID int) ([]CopyWithAuthor, error) {
	rows, err := q.db.Query(ctx, `
		SELECT pc.inventory_number, p.title, a.first_name || ' ' || a.last_name AS author_name
		FROM publications_copy pc
		JOIN publications p ON pc.publication_id = p.id
		JOIN publications_works pw ON p.id = pw.publication_id
		JOIN works w ON pw.work_id = w.id
		JOIN authors a ON w.author = a.id
		WHERE a.id = $1
	`, authorID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []CopyWithAuthor
	for rows.Next() {
		var ca CopyWithAuthor
		if err := rows.Scan(&ca.InventoryNumber, &ca.PublicationTitle, &ca.AuthorName); err != nil {
			return nil, err
		}
		res = append(res, ca)
	}
	return res, nil
}

// 16. Самые популярные произведения (топ-3 по количеству выдач)
func (q *QueryRepo) GetPopularWorks(ctx context.Context) ([]PopularWork, error) {
	rows, err := q.db.Query(ctx, `
		SELECT w.title, COUNT(l.id) AS usage_count
		FROM works w
		JOIN publications_works pw ON w.id = pw.work_id
		JOIN publications_copy pc ON pw.publication_id = pc.publication_id
		JOIN loans l ON pc.inventory_number = l.copy_inventory_number
		GROUP BY w.id
		ORDER BY usage_count DESC
		LIMIT 3
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var res []PopularWork
	for rows.Next() {
		var pw PopularWork
		if err := rows.Scan(&pw.WorkTitle, &pw.UsageCount); err != nil {
			return nil, err
		}
		res = append(res, pw)
	}
	return res, nil
}
