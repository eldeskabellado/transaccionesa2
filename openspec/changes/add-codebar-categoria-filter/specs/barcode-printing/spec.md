## ADDED Requirements

### Requirement: Filtro por Departamento (Categoría)

El formulario de Impresión de Códigos de Barra SHALL incluir un desplegable `cbbCategoria` que permite al usuario seleccionar un departamento como filtro. La lista SHALL cargarse desde la tabla `Scategoria` (campos `FD_CODIGO`, `FD_DESCRIPCION`) ordenada por descripción. El primer ítem SHALL ser `"(Todos)"` que indica que no se aplica filtro. Al seleccionar una categoría, la query `SQDetalleetiquetaInventario1` SHALL incluir `AND I.FI_CATEGORIA = '<FD_CODIGO>'` en su cláusula WHERE.

#### Scenario: Sin filtro de categoría

- **WHEN** el usuario deja `cbbCategoria` en `"(Todos)"`
- **THEN** la query no agrega restricción por `FI_CATEGORIA` y devuelve artículos de todos los departamentos

#### Scenario: Con filtro de categoría

- **WHEN** el usuario selecciona un departamento de `cbbCategoria`
- **THEN** la query agrega `AND I.FI_CATEGORIA = '<código>'` y solo retorna artículos de ese departamento

---

### Requirement: Filtro por Subcategoría

El formulario SHALL incluir un segundo desplegable `cbbSubcategoria` cargado con los valores `DISTINCT` de `SInventario.FI_SUBCATEGORIA` para la categoría seleccionada. No existe tabla maestra de subcategorías: los valores se obtienen directamente de `SInventario`. El desplegable SHALL estar deshabilitado cuando no hay categoría seleccionada. El primer ítem SHALL ser `"(Todos)"`. Al seleccionar subcategoría, la query SHALL agregar `AND I.FI_SUBCATEGORIA = '<valor>'`.

#### Scenario: Subcategoría deshabilitada sin categoría

- **WHEN** `cbbCategoria` está en `"(Todos)"`
- **THEN** `cbbSubcategoria` está vacío y deshabilitado

#### Scenario: Subcategoría se carga al seleccionar categoría

- **WHEN** el usuario selecciona una categoría en `cbbCategoria`
- **THEN** `cbbSubcategoria` se habilita y se puebla con los valores DISTINCT de `FI_SUBCATEGORIA` para esa categoría

#### Scenario: Con filtro de subcategoría

- **WHEN** el usuario selecciona una subcategoría de `cbbSubcategoria`
- **THEN** la query agrega `AND I.FI_SUBCATEGORIA = '<valor>'` y solo retorna artículos de esa subcategoría

#### Scenario: Sin filtro de subcategoría

- **WHEN** el usuario selecciona `"(Todos)"` en `cbbSubcategoria`
- **THEN** la query no agrega restricción por `FI_SUBCATEGORIA`
