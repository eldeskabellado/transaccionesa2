## 1. Formulario (UnitImpresionCodebar.dfm)

- [x] 1.1 Agregar `TLabel` con caption "Departamento:" sobre `cbbCategoria`
- [x] 1.2 Agregar `TComboBox` `cbbCategoria` (Style = csDropDownList, ancho ~220px)
- [x] 1.3 Agregar `TLabel` con caption "Subcategoría:" sobre `cbbSubcategoria`
- [x] 1.4 Agregar `TComboBox` `cbbSubcategoria` (Style = csDropDownList, ancho ~220px, Enabled = False inicialmente)

## 2. Lógica de carga (UnitImpresionCodebar.pas)

- [x] 2.1 Crear procedimiento `CargarCategorias` que:
  - Abre query `SELECT FD_CODIGO, FD_DESCRIPCION FROM Scategoria ORDER BY FD_DESCRIPCION`
  - Puebla `cbbCategoria.Items` con formato `"FD_CODIGO - FD_DESCRIPCION"`
  - Inserta ítem `"(Todos)"` al inicio (índice 0)
- [x] 2.2 Crear procedimiento `CargarSubcategorias(const CodigoCategoria: string)` que:
  - Si `CodigoCategoria` está vacío (selección "Todos"), limpia `cbbSubcategoria` y lo deshabilita
  - Si no, abre query `SELECT DISTINCT FI_SUBCATEGORIA FROM SInventario WHERE FI_CATEGORIA = :cat AND FI_SUBCATEGORIA <> '' ORDER BY FI_SUBCATEGORIA`
  - Puebla `cbbSubcategoria.Items`; inserta `"(Todos)"` al inicio
  - Habilita `cbbSubcategoria`
- [x] 2.3 Llamar `CargarCategorias` en el evento `FormCreate` (o al abrir el formulario)
- [x] 2.4 Implementar `cbbCategoriaChange`: llamar `CargarSubcategorias` con el código de la categoría seleccionada

## 3. Modificar la query de etiquetas (UnitImpresionCodebar.pas)

- [x] 3.1 Crear función auxiliar `GetCodigoCategoria: string` que extrae `FD_CODIGO` del ítem seleccionado en `cbbCategoria` (retorna `''` si seleccionó "Todos")
- [x] 3.2 Crear función auxiliar `GetSubcategoria: string` que retorna el texto seleccionado en `cbbSubcategoria` (retorna `''` si "Todos" o deshabilitado)
- [x] 3.3 En el procedimiento que abre/ejecuta `SQDetalleetiquetaInventario1`:
  - Si `GetCodigoCategoria <> ''`: agregar `AND I.FI_CATEGORIA = '<valor>'` al WHERE existente
  - Si `GetSubcategoria <> ''`: agregar `AND I.FI_SUBCATEGORIA = '<valor>'` al WHERE existente

## 4. Verificación manual

- [ ] 4.1 Compilar y ejecutar Despacha2
- [ ] 4.2 Abrir formulario de Impresión de Códigos de Barra
- [ ] 4.3 Verificar que el desplegable "Departamento" lista todas las categorías de `Scategoria`
- [ ] 4.4 Seleccionar una categoría — verificar que "Subcategoría" se habilita y muestra valores correctos
- [ ] 4.5 Seleccionar "Todos" en Departamento — verificar que Subcategoría se vacía y deshabilita
- [ ] 4.6 Imprimir/previsualizar etiquetas con filtro de categoría — verificar que solo aparecen artículos de esa categoría
- [ ] 4.7 Imprimir/previsualizar con filtro de subcategoría adicional — verificar filtrado correcto
- [ ] 4.8 Sin filtros (ambos en "Todos") — verificar que se comporta igual que antes (todos los artículos)
