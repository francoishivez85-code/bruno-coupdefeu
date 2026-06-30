import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    if (window.matchMedia("(pointer: coarse)").matches) return

    this.canvas = document.createElement("canvas")
    Object.assign(this.canvas.style, {
      position: "fixed", top: "0", left: "0",
      pointerEvents: "none", zIndex: "99999",
      mixBlendMode: "screen",
    })
    document.body.appendChild(this.canvas)
    this.ctx = this.canvas.getContext("2d")

    this.particles = []
    this.mx = 0; this.my = 0
    this.lx = 0; this.ly = 0

    this._onMove  = this.#onMove.bind(this)
    this._onFrame = this.#animate.bind(this)
    this._onResize = this.#resize.bind(this)

    window.addEventListener("mousemove", this._onMove)
    window.addEventListener("resize",    this._onResize)
    this.#resize()
    this.raf = requestAnimationFrame(this._onFrame)
  }

  disconnect() {
    cancelAnimationFrame(this.raf)
    window.removeEventListener("mousemove", this._onMove)
    window.removeEventListener("resize",    this._onResize)
    this.canvas?.remove()
  }

  #resize() {
    this.canvas.width  = window.innerWidth
    this.canvas.height = window.innerHeight
  }

  #onMove(e) {
    const dx = e.clientX - this.lx
    const dy = e.clientY - this.ly
    const speed = Math.sqrt(dx * dx + dy * dy)
    this.mx = e.clientX; this.my = e.clientY
    this.lx = e.clientX; this.ly = e.clientY
    const count = Math.min(Math.ceil(speed * 0.35), 7)
    for (let i = 0; i < count; i++) this.#spawn(speed)
  }

  #spawn(speed) {
    const s = Math.min(speed, 40)
    this.particles.push({
      x:     this.mx + (Math.random() - 0.5) * 6,
      y:     this.my + (Math.random() - 0.5) * 6,
      vx:    (Math.random() - 0.5) * 1.2,
      vy:    -(Math.random() * 2.5 + 1.2),
      life:  1,
      decay: Math.random() * 0.03 + 0.025,
      r:     Math.random() * (s * 0.18 + 3) + 2,
    })
  }

  #animate() {
    const ctx = this.ctx
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height)
    this.particles = this.particles.filter(p => p.life > 0)

    for (const p of this.particles) {
      p.x  += p.vx + (Math.random() - 0.5) * 0.7
      p.y  += p.vy
      p.vy -= 0.04
      p.life -= p.decay
      p.r  *= 0.975

      const a = Math.max(p.life, 0)
      const g = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.r)
      g.addColorStop(0,    `rgba(255,240,180,${a})`)
      g.addColorStop(0.25, `rgba(255,140, 20,${a * 0.9})`)
      g.addColorStop(0.6,  `rgba(255, 61,  0,${a * 0.6})`)
      g.addColorStop(1,    `rgba(180, 20,  0,0)`)

      ctx.save()
      ctx.globalCompositeOperation = "lighter"
      ctx.globalAlpha = a * 0.55
      ctx.beginPath()
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
      ctx.fillStyle = g
      ctx.fill()
      ctx.restore()
    }

    this.raf = requestAnimationFrame(this._onFrame)
  }
}
