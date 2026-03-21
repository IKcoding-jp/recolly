import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { ManualWorkForm } from './ManualWorkForm'

describe('ManualWorkForm', () => {
  it('タイトルとジャンルの入力欄が表示される', () => {
    render(<ManualWorkForm onSubmit={vi.fn()} />)
    expect(screen.getByLabelText('タイトル')).toBeInTheDocument()
    expect(screen.getByLabelText('ジャンル')).toBeInTheDocument()
  })

  it('タイトルとジャンルを入力して送信できる', async () => {
    const onSubmit = vi.fn().mockResolvedValue(undefined)
    render(<ManualWorkForm onSubmit={onSubmit} />)
    const user = userEvent.setup()

    await user.type(screen.getByLabelText('タイトル'), 'テスト作品')
    await user.selectOptions(screen.getByLabelText('ジャンル'), 'anime')
    await user.click(screen.getByRole('button', { name: '登録する' }))

    expect(onSubmit).toHaveBeenCalledWith('テスト作品', 'anime', '')
  })

  it('タイトル未入力でバリデーションエラー', async () => {
    render(<ManualWorkForm onSubmit={vi.fn()} />)
    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: '登録する' }))
    expect(screen.getByText('タイトルを入力してください')).toBeInTheDocument()
  })

  it('登録成功後にフォームがリセットされる', async () => {
    const onSubmit = vi.fn().mockResolvedValue(undefined)
    render(<ManualWorkForm onSubmit={onSubmit} />)
    const user = userEvent.setup()

    await user.type(screen.getByLabelText('タイトル'), 'テスト作品')
    await user.click(screen.getByRole('button', { name: '登録する' }))

    const titleInput = screen.getByLabelText('タイトル') as HTMLInputElement
    expect(titleInput.value).toBe('')
  })
})
