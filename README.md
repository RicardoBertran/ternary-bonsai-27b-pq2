# Ternary Bonsai 27B PQ2_0 en Windows

Instalación, configuración y pruebas reales de **Ternary Bonsai 27B** ejecutado localmente en Windows con `llama.cpp` y los binarios de Prism ML.

La prueba usa `Ternary-Bonsai-27B-PQ2_0.gguf`: un empaquetado ternario de aproximadamente 2 bits, 27,3 mil millones de parámetros y 7,17 GB. El objetivo de este repositorio es conservar una configuración reproducible y documentar tanto lo que funcionó como los fallos observados.

## Resultado rápido

| Prueba | Resultado | Velocidad |
|---|---|---:|
| Tres cajas mal etiquetadas | Correcta | 59,64 t/s |
| Landing HTML/CSS/JS | 7.105 tokens; incompleta por un error CSS | 59,66 t/s |

Estas cifras no son un benchmark estandarizado. Son mediciones de dos pruebas prácticas realizadas en el mismo equipo.

## Equipo y versiones probadas

| Elemento | Valor |
|---|---|
| GPU | NVIDIA GeForce RTX 5070 |
| VRAM | 12 GB |
| Sistema | Windows |
| Driver NVIDIA | 616.56 |
| CUDA indicada por el driver | 13.4 |
| Modelo | Ternary Bonsai 27B |
| Archivo | `Ternary-Bonsai-27B-PQ2_0.gguf` |
| Tamaño | 7.165.121.600 bytes (~7,17 GB) |
| Runtime probado | Prism ML `llama.cpp` |
| Build probada | 10683, commit `d8f26eec7` |

## Formatos compatibles

`PQ2_0` es el empaquetado group-128 propio de Prism. La build usada en estas pruebas lo carga directamente. Si una build no reconoce el tipo GGML, puede mostrar un error como:

```text
tensor 'output.weight' has invalid ggml type 142
```

Para una build estándar de `llama.cpp`, usa la variante group-64 publicada como `Ternary-Bonsai-27B-Q2_g64.gguf`. No basta con cambiar el nombre del archivo: son formatos distintos.

El repositorio oficial del modelo mantiene la información más reciente sobre formatos y backends:

- [Ternary Bonsai 27B GGUF](https://huggingface.co/prism-ml/Ternary-Bonsai-27B-gguf)
- [Bonsai Demo](https://github.com/PrismML-Eng/Bonsai-demo)
- [Fork de llama.cpp de Prism ML](https://github.com/PrismML-Eng/llama.cpp)

## Instalación

### 1. Descargar el modelo

Descarga `Ternary-Bonsai-27B-PQ2_0.gguf` desde el repositorio oficial. En el equipo de prueba se guardó en:

```text
E:\models\Ternary-Bonsai-27B-PQ2_0.gguf
```

### 2. Preparar llama.cpp

La prueba se realizó con la build `10683` del fork de Prism ML. Los binarios y las DLL CUDA se extrajeron juntos en un directorio limpio:

```text
E:\llama-prism-clean\
```

No mezcles DLL de builds distintas. Para comprobar el ejecutable:

```powershell
& "E:\llama-prism-clean\llama-server.exe" --version
```

La salida de la build probada fue:

```text
version: 0.2.0-dev (build 10683, commit d8f26eec7)
built with MSVC 19.44.35228.0 for Windows AMD64
```

Si `llama-server.exe` termina con el código `-1073741515`, revisa primero las dependencias CUDA del directorio del ejecutable.

### 3. Ajustar las rutas

Edita la ruta `m` de [`config/modelos-web.ini`](config/modelos-web.ini) si el GGUF está en otra carpeta.

Los scripts aceptan rutas alternativas mediante las variables `PRISM_DIR` y `MODEL_DIR`; si no se definen, usan las rutas del equipo de prueba.

## Configuración probada

El preset usa:

- contexto de 24.576 tokens;
- una sola secuencia en paralelo;
- flash attention;
- caché K/V `q8_0`;
- todas las capas en GPU;
- muestreo `temp 0.7`, `top-p 0.95` y `top-k 20`.

El contexto máximo publicado por el modelo es mayor, pero **24.576 es la configuración que se probó aquí** en 12 GB de VRAM.

## Arranque

Ejecuta:

```text
scripts\ARRANQUE-BONSAI-PRISM.bat
```

Después abre:

```text
http://127.0.0.1:8080
```

El script busca `llama-server.exe` en `E:\llama-prism-clean` de forma predeterminada. Para otra ruta:

```bat
set PRISM_DIR=D:\aplicaciones\llama-prism
scripts\ARRANQUE-BONSAI-PRISM.bat
```

## Pruebas

### Razonamiento

El problema de las tres cajas mal etiquetadas se resolvió correctamente a **59,64 tokens por segundo**. El prompt exacto está en [`prompts/razonamiento-cajas.txt`](prompts/razonamiento-cajas.txt).

### Generación de código

El modelo produjo **7.105 tokens** de HTML, CSS y JavaScript a **59,66 tokens por segundo**. El hero se renderizó correctamente, pero otras secciones quedaron ocultas por este error:

```css
.reveal{opacity:0;transform:translateY(40px};transition:all .6s ease}
```

La llave después de `40px` debería ser un paréntesis. Como `.reveal` dependía de un `IntersectionObserver`, el fallo impidió mostrar correctamente varias secciones.

Consulta [`RESULTADOS.md`](RESULTADOS.md) para las notas completas.

## Estructura

```text
config/      Preset de llama-server usado en la prueba.
scripts/     Arranque y comprobación del entorno.
prompts/     Prompts exactos de las dos pruebas.
RESULTADOS.md
```

Este repositorio no contiene los pesos del modelo, binarios de `llama.cpp`, DLL CUDA ni archivos ZIP. La licencia MIT cubre únicamente la documentación, configuración y scripts propios de este repositorio; el modelo y las herramientas de terceros conservan sus licencias respectivas.
