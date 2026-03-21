import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { StatusFilter } from './StatusFilter'

describe('StatusFilter', () => {
  it('「すべて」を含む全ステータスが表示される', () => {
    render(<StatusFilter value={null} onChange={() => {}} />)
    expect(screen.getByRole('button', { name: 'すべて' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '視聴中' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '視聴完了' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '一時停止' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '中断' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: '視聴予定' })).toBeInTheDocument()
  })

  it('value が null のとき「すべて」がアクティブ', () => {
    render(<StatusFilter value={null} onChange={() => {}} />)
    expect(screen.getByRole('button', { name: 'すべて' }).className).toContain('active')
  })

  it('value が watching のとき「視聴中」がアクティブ', () => {
    render(<StatusFilter value="watching" onChange={() => {}} />)
    expect(screen.getByRole('button', { name: '視聴中' }).className).toContain('active')
  })

  it('ステータスボタンクリックで onChange が呼ばれる', async () => {
    const user = userEvent.setup()
    const handleChange = vi.fn()
    render(<StatusFilter value={null} onChange={handleChange} />)
    await user.click(screen.getByRole('button', { name: '視聴中' }))
    expect(handleChange).toHaveBeenCalledWith('watching')
  })

  it('「すべて」クリックで null が渡される', async () => {
    const user = userEvent.setup()
    const handleChange = vi.fn()
    render(<StatusFilter value="watching" onChange={handleChange} />)
    await user.click(screen.getByRole('button', { name: 'すべて' }))
    expect(handleChange).toHaveBeenCalledWith(null)
  })
})
