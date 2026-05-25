package main

import (
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"
	"library-management/internal/auth"
	"library-management/internal/config"
	"library-management/internal/database"
	"library-management/internal/handler"
	"library-management/internal/middleware"
	"library-management/internal/repository"
	"library-management/internal/service"
	"log"
	"net/http"
)

func main() {
	cfg := config.Load()

	// Миграции
	if err := database.RunMigrations(cfg.GetDBURL()); err != nil {
		log.Fatalf("Migration failed: %v", err)
	}

	// Подключение к БД
	dbConn, err := database.New(cfg)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer dbConn.Close()

	// Инициализация JWT
	auth.InitJWT(cfg.JWTSecret)

	// Репозитории
	userRepo := repository.NewUserRepo(dbConn.Pool)
	readerRepo := repository.NewReaderRepo(dbConn.Pool)
	publicationRepo := repository.NewPublicationRepo(dbConn.Pool)
	loanRepo := repository.NewLoanRepo(dbConn.Pool)
	employeeRepo := repository.NewEmployeeRepo(dbConn.Pool)
	queryRepo := repository.NewQueryRepo(dbConn.Pool)

	// Сервисы
	authService := service.NewAuthService(userRepo, readerRepo, employeeRepo)
	readerService := service.NewReaderService(readerRepo)

	// Хендлеры
	authHandler := handler.NewAuthHandler(authService)
	readerHandler := handler.NewReaderHandler(readerService)
	publicationHandler := handler.NewPublicationHandler(publicationRepo)
	copyHandler := handler.NewCopyHandler(publicationRepo)
	loanHandler := handler.NewLoanHandler(loanRepo)
	queryHandler := handler.NewQueryHandler(queryRepo)

	// Роутер
	r := chi.NewRouter()

	// Глобальные middleware (ДО ЛЮБЫХ МАРШРУТОВ)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		AllowCredentials: true,
	}))

	// Публичные маршруты (не требуют аутентификации)
	r.Post("/api/register", authHandler.Register)
	r.Post("/api/login", authHandler.Login)

	// Статические файлы для веб-клиента
	fs := http.FileServer(http.Dir("internal/web/static"))
	r.Handle("/static/*", http.StripPrefix("/static/", fs))
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "internal/web/index.html")
	})

	// Защищённые маршруты (требуют аутентификации)
	r.Group(func(r chi.Router) {
		r.Use(middleware.AuthMiddleware) // применяется только к этой группе

		// Читатели
		r.Get("/api/readers", readerHandler.List)
		r.Get("/api/readers/{id}", readerHandler.GetByID)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Post("/api/readers", readerHandler.Create)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Put("/api/readers/{id}", readerHandler.Update)
		r.With(middleware.RoleMiddleware("admin")).Delete("/api/readers/{id}", readerHandler.Delete)
		r.Get("/api/reader-categories", readerHandler.GetCategories)
		r.Get("/api/libraries", readerHandler.GetLibraries)
		r.Get("/api/loans/all", loanHandler.GetAllLoans)

		// Публикации
		r.Get("/api/publications", publicationHandler.ListPublications)
		r.Get("/api/publications/{id}", publicationHandler.GetPublication)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Post("/api/publications", publicationHandler.CreatePublication)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Put("/api/publications/{id}", publicationHandler.UpdatePublication)
		r.With(middleware.RoleMiddleware("admin")).Delete("/api/publications/{id}", publicationHandler.DeletePublication)

		// Правила выдачи
		r.Get("/api/publications/{id}/rules", publicationHandler.GetPublicationRules)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Put("/api/publications/{id}/rules", publicationHandler.SetPublicationRules)

		// Экземпляры
		r.With(middleware.RoleMiddleware("admin", "librarian")).Post("/api/copies", copyHandler.CreateCopy)
		r.Get("/api/copies/{inventory_number}", copyHandler.GetCopy)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Put("/api/copies/{inventory_number}", copyHandler.UpdateCopy)
		r.With(middleware.RoleMiddleware("admin")).Delete("/api/copies/{inventory_number}", copyHandler.DeleteCopy)
		r.With(middleware.RoleMiddleware("admin")).Post("/api/copies/{inventory_number}/write-off", copyHandler.WriteOffCopy)

		// Выдачи
		r.With(middleware.RoleMiddleware("admin", "librarian")).Post("/api/loans", loanHandler.CreateLoan)
		r.With(middleware.RoleMiddleware("admin", "librarian")).Put("/api/loans/{id}/return", loanHandler.ReturnLoan)
		r.Get("/api/loans/reader/{reader_id}", loanHandler.GetLoansByReader)
		r.Get("/api/loans/active", loanHandler.GetActiveLoans)

		// 16 запросов (отчёты)
		r.Get("/api/queries/readers-by-attribute", queryHandler.GetReadersByAttribute)
		r.Get("/api/queries/readers-by-work-on-hands", queryHandler.GetReadersByWorkOnHands)
		r.Get("/api/queries/readers-by-publication-on-hands", queryHandler.GetReadersByPublicationOnHands)
		r.Get("/api/queries/readers-by-work-in-period", queryHandler.GetReadersByWorkInPeriod)
		r.Get("/api/queries/publications-from-own-library", queryHandler.GetPublicationsFromOwnLibrary)
		r.Get("/api/queries/publications-from-other-library", queryHandler.GetPublicationsFromOtherLibrary)
		r.Get("/api/queries/loaned-from-shelf", queryHandler.GetLoanedFromShelf)
		r.Get("/api/queries/readers-served-by-employee", queryHandler.GetReadersServedByEmployee)
		r.Get("/api/queries/employee-workload", queryHandler.GetEmployeeWorkload)
		r.Get("/api/queries/readers-with-overdue", queryHandler.GetReadersWithOverdue)
		r.Get("/api/queries/copy-movements", queryHandler.GetCopyMovements)
		r.Get("/api/queries/employees-by-reading-room", queryHandler.GetEmployeesByReadingRoom)
		r.Get("/api/queries/inactive-readers", queryHandler.GetInactiveReaders)
		r.Get("/api/queries/copies-by-work", queryHandler.GetCopiesByWork)
		r.Get("/api/queries/copies-by-author", queryHandler.GetCopiesByAuthor)
		r.Get("/api/queries/popular-works", queryHandler.GetPopularWorks)
	})

	log.Printf("Server starting on :%s", cfg.ServerPort)
	if err := http.ListenAndServe(":"+cfg.ServerPort, r); err != nil {
		log.Fatal(err)
	}
}
