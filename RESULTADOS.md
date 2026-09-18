# Resultados

Resultados obtenidos con Ternary Bonsai 27B PQ2_0 en una NVIDIA GeForce RTX 5070 de 12 GB.

No son benchmarks estandarizados. Son dos pruebas prácticas realizadas con la misma instalación para comprobar razonamiento, generación larga y estabilidad.

## Entorno

| Elemento | Valor |
|---|---|
| GPU | NVIDIA GeForce RTX 5070, 12 GB |
| Driver | 616.56 |
| CUDA indicada por el driver | 13.4 |
| llama.cpp | Prism build 10683 |
| Commit | `d8f26eec7` |
| Modelo | Ternary Bonsai 27B |
| Formato | `PQ2_0` |
| Tamaño del GGUF | 7.165.121.600 bytes |
| Contexto configurado | 24.576 tokens |

## Prueba 1: razonamiento

### Prompt

```text
Tienes tres cajas. Una contiene solo manzanas, otra solo naranjas y otra una mezcla de ambas. Todas las etiquetas están mal. Solo puedes sacar una fruta de una caja, sin mirar dentro. ¿Cómo puedes identificar correctamente las tres cajas? Explícalo de forma breve.
```

### Resultado

El modelo identificó correctamente que había que extraer una fruta de la caja etiquetada como mezcla. Como todas las etiquetas eran incorrectas, esa caja no podía contener una mezcla; la fruta extraída permitía identificarla y deducir las otras dos.

| Métrica | Valor |
|---|---:|
| Velocidad | 59,64 t/s |
| Valoración | Correcta |

No se observaron problemas relevantes en esta tarea.

## Prueba 2: landing page

El prompt completo está en [`prompts/landing-nexa-ai.txt`](prompts/landing-nexa-ai.txt). Se pidió un único archivo HTML con CSS y JavaScript, sin librerías externas.

| Métrica | Valor |
|---|---:|
| Tokens generados | 7.105 |
| Velocidad | 59,66 t/s |
| Tiempo observado | Casi 2 minutos |

La portada se renderizó correctamente y el aspecto inicial era razonable. Al navegar a las secciones de características y precios, parte del contenido quedó vacío.

### Error localizado

```css
.reveal{opacity:0;transform:translateY(40px};transition:all .6s ease}
```

La expresión contenía:

```text
translateY(40px}
```

en lugar de:

```text
translateY(40px)
```

Las secciones usaban `.reveal` y un `IntersectionObserver` para aparecer al entrar en pantalla. El error de sintaxis rompió esa animación y dejó contenido oculto.

También apareció una mezcla de idiomas en un encabezado:

```text
que Piensa Con Você
```

### Valoración

La prueba demuestra que el modelo puede sostener una generación larga a una velocidad estable, pero el resultado no fue fiable sin revisión. Un único carácter incorrecto tuvo impacto en varias secciones de la página.

## Resumen

| Prueba | Resultado | Velocidad |
|---|---|---:|
| Razonamiento | Correcta | 59,64 t/s |
| Landing HTML/CSS/JS | Generada, con errores | 59,66 t/s |

El modelo entró completamente en la GPU y mantuvo prácticamente la misma velocidad en ambas tareas. La prueba de código muestra la diferencia entre producir una salida convincente y producir una salida lista para usar sin revisión.
