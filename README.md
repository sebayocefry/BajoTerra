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


## ⚙️ Configuración de Físicas y Nodos (Obligatorio)

Para evitar crasheos y errores de movimiento (como el "efecto velcro" en los muros) al crear o duplicar enemigos, todo el equipo debe respetar estas reglas en el Inspector:

### 1. Movimiento Top-Down (Floating)
Godot aplica por defecto físicas de gravedad (Grounded). Para **BajoTerra**, esto debe cambiarse para permitir deslizamiento fluido:
* **Nodo:** Raíz del enemigo (`CharacterBody2D`).
* **Propiedad:** `Motion Mode` -> Cambiar a **`Floating`**.

### 2. Estandarización de Nombres (Case Sensitive)
Los scripts de la Máquina de Estados fallarán si los nombres no son exactos. Se debe respetar estrictamente el uso de mayúsculas:
* **Área de detección:** Debe llamarse exactamente `Zona_ataque`.
* **Gestor de IA:** Debe llamarse exactamente `Maquina_estados`.

### 3. Optimización de Colisiones (Pies)
Para evitar que el enemigo se trabe en las esquinas de los pasillos:
* **Forma:** Usar preferentemente `CapsuleShape2D` o `CircleShape2D`.
* **Posición:** Ajustar la colisión **solo a los pies** del sprite. Esto permite que el cuerpo visual pueda "solaparse" un poco con los muros, dando una sensación de profundidad y evitando atascos mecánicos(este ultimo punto es solo por gusto de cada uno, ahi deciden eso ustedes).

> [!IMPORTANT]
> **Jerarquía de Nodos:** Nunca pongas un Area2D como hijo de un CollisionShape2D. La estructura correcta es: `Enemigo (Root) > Zona_ataque (Area2D) > CollisionShape2D (Hijo)`.




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

#### 5. Cristales y Botín (`Area2D`)
* **Layer:** 5 (`Objetos / Loot`)
* **Mask:** 2 (`Jugador`)
* **Descripción:** Elementos recolectables que el enemigo suelta al morir.

* **Nota Técnica:** Al estar en la Capa 5, los proyectiles (que miran Capas 1 y 3) no chocarán con el botín, permitiendo disparar a través de él sin perder la bala.

⚠️ **Nota para el equipo:** Nunca programen colisiones con `if body.name == "Muro"`. usen las mask. Si un objeto está en la capa correcta, la física funcionará sola.

