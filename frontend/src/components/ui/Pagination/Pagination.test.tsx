import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Pagination } from './Pagination'

describe('Pagination', () => {
  it('現在ページと総ページ数が表示される', () => {
    render(<Pagination currentPage={2} totalPages={5} onPageChange={() => {}} />)
    expect(screen.getByText('2 / 5')).toBeInTheDocument()
  })

  it('1ページ目で「前へ」が無効', () => {
    render(<Pagination currentPage={1} totalPages={3} onPageChange={() => {}} />)
    expect(screen.getByRole('button', { name: '前へ' })).toBeDisabled()
  })

  it('最終ページで「次へ」が無効', () => {
    render(<Pagination currentPage={3} totalPages={3} onPageChange={() => {}} />)
    expect(screen.getByRole('button', { name: '次へ' })).toBeDisabled()
  })

  it('「次へ」クリックで currentPage + 1 が渡される', async () => {
    const user = userEvent.setup()
    const handleChange = vi.fn()
    render(<Pagination currentPage={1} totalPages={3} onPageChange={handleChange} />)
    await user.click(screen.getByRole('button', { name: '次へ' }))
    expect(handleChange).toHaveBeenCalledWith(2)
  })

  it('「前へ」クリックで currentPage - 1 が渡される', async () => {
    const user = userEvent.setup()
    const handleChange = vi.fn()
    render(<Pagination currentPage={2} totalPages={3} onPageChange={handleChange} />)
    await user.click(screen.getByRole('button', { name: '前へ' }))
    expect(handleChange).toHaveBeenCalledWith(1)
  })

  it('totalPages が 1 のときは表示しない', () => {
    const { container } = render(
      <Pagination currentPage={1} totalPages={1} onPageChange={() => {}} />,
    )
    expect(container.firstChild).toBeNull()
  })
})
