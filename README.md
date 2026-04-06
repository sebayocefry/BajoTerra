# BajoTerra


## Patrones de diseño utilizados:

**State**
    lo usamos para cambiar el comportamiento del enmigo y probablemente lo usare para jugador




##  Guia de Animaciones para Enemigos

Para mantener el orden en el codigo de BajoTerra, todos los enemigos base deben configurar sus animaciones en el nodo `AnimationPlayer` y enlazarlas en el Inspector del nodo raíz.

**Nombres por Defecto (Recomendados):**
- **Reposo (Idle):** `idle`
- **Movimiento:** `correr`
- **Ataque:** `atacar`

*Nota:* Si un enemigo necesita animaciones con nombres distintos (ej. `caminar_lento`), el animador solo debe cambiar el nombre en la sección "Nombres de Animaciones" del Inspector en Godot. **No es necesario modificar el script de la clase.**