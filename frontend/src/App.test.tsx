import { render, screen } from '@testing-library/react'
import App from './App'

describe('App', () => {
  it('エラーなくレンダリングされる', () => {
    render(<App />)
    expect(screen.getByText('Recolly')).toBeInTheDocument()
  })
})
