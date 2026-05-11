# BajoTerra


## Patrones de diseño utilizados:

**State**
    lo usamos para cambiar el comportamiento del enmigo y probablemente lo usare para jugador

***Observer**
    Es un patrón de diseño de comportamiento que permite definir un mecanismo de suscripción para notificar a múltiples objetos (la GUI, efectos de sonido, logros) sobre cualquier evento que le suceda al objeto que están observando (el Jugador), sin que estos objetos estén acoplados entre sí.

    lo usamos: Para respetar el principio de Desacoplamiento. El Jugador no necesita saber que la GUI existe; solo emite una señal al Eventos.gd y quien esté interesado, que escuche el evento.

**Singleton (Autoload)**
Es un patrón de diseño creacional que garantiza que una clase tenga una única instancia y proporciona un punto de acceso global a ella. En Godot, lo implementamos mediante los nodos **Autoload**.

* **Uso en BajoTerra:** Se utiliza en `DatosJugador.gd`, `GestorEscenas.gd` y `Eventos.gd`.
* **Propósito:** Mantener la persistencia de datos (vida, oro, inventario) y coordinar sistemas globales que no deben destruirse al cambiar de escena.

### **Memento / Snapshot**
Es un patrón de diseño de comportamiento que permite capturar y externalizar el estado interno de un objeto sin violar su encapsulamiento, de modo que el objeto pueda restaurarse a este estado más tarde.

* **Uso en BajoTerra:** El `GestorEscenas` captura una "foto" de las variables locales del `Player` antes de destruir el nivel y las reinyecta en el nuevo `Player` al cargar la siguiente habitación.
* **Propósito:** Evitar que el jugador pierda su progreso al transicionar entre archivos `.tscn`.

### **Mediator (Controlador de Nivel)**
Es un patrón de diseño de comportamiento que reduce las dependencias caóticas entre objetos. El patrón restringe las comunicaciones directas entre los objetos y los obliga a colaborar únicamente a través de un objeto mediador.

* **Uso en BajoTerra:** La clase `ControladorNivel.gd` actúa como mediador entre los enemigos y la puerta de salida (`PuntoSalida`).
* **Propósito:** Los enemigos no necesitan conocer la existencia de la puerta; simplemente avisan que murieron y el mediador decide cuándo abrir el camino basándose en el estado de la habitación.






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
| **5** | Botín / Loot | Cristales y objetos recolectables. |
| **6** | **Interactivos** | Zonas de activación (E) para guardado, cofres o diálogos. |

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



# Arquitectura de Progresión y Persistencia en BajoTerra

Este sistema gestiona la transición entre niveles y habitaciones asegurando la persistencia del estado del jugador y la "memoria" del mundo (enemigos que no reviven). Se basa en el **Patrón Snapshot** y el uso de **Singletons (Autoloads)** para desacoplar los datos de las escenas físicas.

---

## 1. Componentes del Sistema

### A. DatosJugador (Singleton de Persistencia)
Es la "Fuente Única de Verdad". Este script nunca se destruye y almacena el estado del jugador durante los cambios de escena.
* **Responsabilidad:** Guardar vida, maná, oro, inventario y el registro de habitaciones ya completadas (`habitaciones_limpias`).
* **Lógica:** Antes de salir de una habitación, captura una "foto" de las estadísticas del jugador y las reinyecta en el nuevo nodo `Player` al cargar la siguiente escena.

### B. GestorEscenas (Singleton de Control)
Es el encargado de ejecutar la transición técnica entre archivos `.tscn`.
* **Responsabilidad:** Orquestar el guardado de datos, realizar el cambio de escena mediante `call_deferred` (para evitar errores de colisión en tiempo de ejecución) e inyectar los datos guardados en el nuevo nivel.

### C. ControladorNivel (Cerebro de la Habitación)
Script adjunto al nodo raíz de cada nivel o habitación.
* **Responsabilidad:** Consultar al inicio si la habitación ya fue marcada como "limpia" en `DatosJugador`. Si es así, elimina a los enemigos automáticamente. Si no, coordina la apertura de la salida cuando el contador de enemigos llega a cero.

### D. PuntoSalida (Interacción)
Nodo `Area2D` que detecta la llegada del jugador.
* **Responsabilidad:** Determinar si el cambio es hacia una nueva habitación (mismo piso) o hacia un nivel final (cambio de piso), notificando al `GestorEscenas` para iniciar la transición.

---

## 2. Configuración en el Motor (Godot)

### Registro de Autoloads
Para que el sistema funcione, los scripts globales deben registrarse en **Proyecto -> Configuración del Proyecto -> Autoload**:

1. **DatosJugador**: Registrar `res://scripts/autoLoad/DatosJugador.gd`.
2. **GestorEscenas**: Registrar `res://scripts/autoLoad/GestorEscenas.gd`.
3. **Eventos**: Registrar `res://scripts/autoLoad/Eventos.gd`.

*Nota: Es fundamental que `DatosJugador` esté por encima de `GestorEscenas` en la lista para asegurar el orden de inicialización.*

### Identificación del Jugador
Para que el sistema encuentre al personaje tras el cambio de escena, el nodo raíz de la escena del jugador (`Player.tscn`) **debe** pertenecer al grupo **"Player"** (Panel de Nodos -> Grupos).

---

## 3. Flujo de Trabajo para Crear Niveles

1. **Crear Escena:** Crear una nueva escena `Node2D` para la habitación.
2. **Asignar Controlador:** Vincular el script `ControladorNivel.gd` al nodo raíz de la escena.
3. **Configurar Salida:** Instanciar la escena `PuntoSalida`. En el Inspector, definir el `Tipo de Salida` y arrastrar el archivo `.tscn` de destino al campo `Siguiente Nivel`.
4. **Etiquetar Enemigos:** Todos los enemigos posicionados en la habitación deben pertenecer al grupo **"Enemigos"**.

---

## 4. Beneficios de esta Arquitectura

* **Escalabilidad:** Se puede añadir un número infinito de habitaciones sin duplicar lógica de código.
* **Persistencia:** El jugador mantiene su progreso (vida/objetos) de forma transparente entre cargas.
* **Memoria de Mundo:** Permite volver a habitaciones anteriores sin que el estado se resetee (los enemigos muertos permanecen muertos).
* **Desacoplamiento:** La lógica de combate (Entidad) no depende de la lógica de guardado (DatosJugador), facilitando el testeo aislado.


### 💾 Guía para el Equipo: Cómo Crear Nuevos Puntos de Guardado

Para mantener la coherencia visual y lógica de *BajoTerra*, sigan estos pasos al crear nuevos puntos de descanso o guardado:

#### 1. Estructura de la Escena
No creen el objeto desde cero. Utilicen la escena base `PuntoGuardado.tscn` como plantilla o creen una **Escena Heredada** para asegurar que la lógica de guardado no se rompa.

* **Nodo Raíz (`StaticBody2D`):** Debe estar en la **Capa 1** para que el jugador no atraviese al NPC.
* **ZonaInteraccion (`Area2D`):** Este es el "sensor". Debe estar en la **Capa 6** y su **Mask** debe ser exclusivamente la **Capa 2** (Jugador).
* **Sprite2D:** Aquí pueden cambiar la imagen por un NPC, un tótem, una fogata o cualquier entidad del lore.

#### 2. Configuración en el Inspector
El script `PuntoGuardado.gd` es modular. No necesitan tocar el código para personalizarlo:

1.  **Cambiar el Visual:** Simplemente arrastren la nueva textura al nodo `Sprite2D`.
2.  **Ajustar el área:** Si el NPC es muy grande, escalen el `CollisionShape2D` del nodo `ZonaInteraccion`.
3.  **Identificador de Diálogo:** (Opcional) Si el NPC tiene líneas de texto únicas, cambien la variable exportada `id_dialogo` para que el gestor de diálogos sepa qué decir antes de guardar.

#### 3. Reglas de Oro para el Equipo
* **Validación de Clase:** El sistema solo permite guardar si el cuerpo detectado es de la clase `Player`. Asegúrense de que el script del jugador mantenga su `class_name`.
* **Ubicación:** No coloquen puntos de guardado cerca de bordes de pantalla o zonas de transición de nivel (Puertas), para evitar conflictos entre el guardado de datos y el cambio de escena asíncrono.