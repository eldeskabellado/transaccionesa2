# Change: Filtros de Categoría y Subcategoría en Impresión de Códigos de Barra

## Why

Actualmente, el formulario `formCodebar` (`UnitImpresionCodebar`) carga **todos** los artículos del inventario en la query `SQDetalleetiquetaInventario1`. Cuando el inventario es grande, el usuario debe imprimir etiquetas para artículos de una categoría o subcategoría específica sin ningún mecanismo de filtrado, lo que obliga a imprimir toda la lista o buscar manualmente.

## What Changes

- Agregar un `TComboBox` (`cbbCategoria`) al formulario cargado con los registros de `Scategoria` (código + descripción).
- Agregar un segundo `TComboBox` (`cbbSubcategoria`) cargado con los valores **DISTINCT** de `SInventario.FI_SUBCATEGORIA` filtrados por la categoría seleccionada.
- Agregar labels descriptivos para cada desplegable.
- Modificar la query `SQDetalleetiquetaInventario1` para incluir cláusulas `WHERE` opcionales según los filtros seleccionados.
- `cbbSubcategoria` se habilita/deshabilita y recarga al cambiar `cbbCategoria`.
- Ambos filtros son opcionales: si se deja en "Todos", no se aplica restricción.

## Impact

- **Affected specs:** `barcode-printing` (nuevo)
- **Affected code:**
  - `UnitImpresionCodebar.dfm` — agregar controles al formulario
  - `UnitImpresionCodebar.pas` — lógica de carga y filtrado
