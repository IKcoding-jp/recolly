import styles from './Pagination.module.css'

type PaginationProps = {
  currentPage: number
  totalPages: number
  onPageChange: (page: number) => void
}

export function Pagination({ currentPage, totalPages, onPageChange }: PaginationProps) {
  if (totalPages <= 1) {
    return null
  }

  const isFirstPage = currentPage === 1
  const isLastPage = currentPage === totalPages

  return (
    <nav className={styles.container} aria-label="ページネーション">
      <button
        type="button"
        className={styles.button}
        disabled={isFirstPage}
        onClick={() => onPageChange(currentPage - 1)}
        aria-label="前へ"
      >
        前へ
      </button>
      <span className={styles.info}>
        {currentPage} / {totalPages}
      </span>
      <button
        type="button"
        className={styles.button}
        disabled={isLastPage}
        onClick={() => onPageChange(currentPage + 1)}
        aria-label="次へ"
      >
        次へ
      </button>
    </nav>
  )
}
