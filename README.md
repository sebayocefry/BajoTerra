# BajoTerra


## Patrones de diseño utilizados:

**State**
    lo usamos para cambiar el comportamiento del enmigo y probablemente lo usare para jugador

***Observer**
    Es un patrón de diseño de comportamiento que permite definir un mecanismo de suscripción para notificar a múltiples objetos (la GUI, efectos de sonido, logros) sobre cualquier evento que le suceda al objeto que están observando (el Jugador), sin que estos objetos estén acoplados entre sí.

    lo usamos: Para respetar el principio de Desacoplamiento. El Jugador no necesita saber que la GUI existe; solo emite una señal al Eventos.gd y quien esté interesado, que escuche el evento.




##  Guia de Animaciones para Enemigos

Para mantener el orden en el codigo de BajoTerra, todos los enemigos base deben configurar sus animaciones en el nodo `AnimationPlayer` y enlazarlas en el Inspector del nodo raíz.

**Nombres por Defecto (Recomendados):**
- **Reposo (Idle):** `idle`
- **Movimiento:** `correr`
- **Ataque:** `atacar`

*Nota:* Si un enemigo necesita animaciones con nombres distintos (ej. `caminar_lento`), el animador solo debe cambiar el nombre en la sección "Nombres de Animaciones" del Inspector en Godot. **No es necesario modificar el script de la clase.**


> **Regla  (Duck Typing Físico):**
> * **Layer (Etiqueta):** "Lo que soy". En qué capa existe físicamente este objeto.
> * **Mask (Lentes):** "Lo que busco". Con qué capas choca o interactúa este objeto.

###  Nombres de Capas Globales (project.godot)
*Todo nuevo nivel, habitación o mapa debe respetar esta distribución:*

| Capa | Nombre | Descripción |
| :--- | :--- | :--- |
| **1** | `Muros` | Obstáculos físicos estáticos (Paredes, Rocas, TileMaps). Nada los atraviesa. |
| **2** | `Jugador` | El Minero / Entidad controlada por el usuario. |
| **3** | `Enemigos` | NPCs hostiles (Fantasmas, Jefes, etc.). |
| **4** | `Proyectiles` | Ataques a distancia o magia. |

---

### ⚙️ Configuración Estándar por Nodo

Para agregar un nuevo elemento al juego, configura su sección **Collision** de la siguiente manera:

#### 1. Muros y Obstáculos (`StaticBody2D` o TileMaps)
* **Layer:** 1 (`Muros`)
* **Mask:** [Ninguna] *(Son estáticos, no buscan chocar)*

#### 2. Jugador (`CharacterBody2D`)
* **Layer:** 2 (`Jugador`)
* **Mask:** 1 (`Muros`), 3 (`Enemigos`) *(Choca con paredes y percibe a los enemigos)*

#### 3. Enemigos (`CharacterBody2D`)
* **Layer:** 3 (`Enemigos`)
* **Mask:** 1 (`Muros`), 2 (`Jugador`) *(No atraviesa paredes y detecta al Minero)*

#### 4. Proyectiles y Balas (`Area2D`)
* **Layer:** [Ninguna] *(Para evitar que las balas choquen entre ellas en el aire)*
* **Mask:** 1 (`Muros`), 3 (`Enemigos`) *(Al chocar con muro se destruyen, al chocar con enemigo aplican `recibir_dano()` y se destruyen)*

⚠️ **Nota para el equipo:** Nunca programen colisiones con `if body.name == "Muro"`. usen las mask. Si un objeto está en la capa correcta, la física funcionará sola.