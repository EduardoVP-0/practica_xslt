<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    <!-- PARAMETRO DE LA TRANSFORMACION: FILTRO POR CATEGORIA           -->
    <!-- Por defecto tiene el valor 'Todos' si no se le envia nada      -->
    <xsl:param name="categoriaFiltro" select="'Todos'" />

    <!-- Plantilla principal que coincide con la raiz del XML -->
    <xsl:template match="/">
        <html lang="es">
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Catalogo Tecnologico</title>
            
            <link rel="preconnect" href="https://fonts.googleapis.com" />
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;450;500;600;700&amp;family=Lora:ital,wght@0,400;0,500;1,400&amp;display=swap" rel="stylesheet" />

            <style>
                :root {
                    --color-midnight-ink: #080b12;
                    --color-paper: #ffffff;
                    --color-fog: #f6f7f8;
                    --color-pearl: #edeef1;
                    --color-stone: #d9d9d9;
                    --color-lavender-mist: #dbdbee;
                    --color-steel: #848a9c;
                    --color-graphite: #6c6d73;
                    --color-charcoal: #2b2b2c;
                    --color-electric-iris: #0a33ff;
                    
                    /* Badges con tinta oscura sobre base pastel */
                    --badge-comp-bg: #e2efff;
                    --badge-comp-ink: #061353;
                    --badge-mon-bg: #ffe6f7;
                    --badge-mon-ink: #600537;
                    --badge-acc-bg: #fee8dd;
                    --badge-acc-ink: #581c01;
                    --badge-top-bg: #e4f3e2;
                    --badge-top-ink: #03350f;
                    
                    /* Radios y elevaciones */
                    --radius-cards: 4px;
                    --radius-badges: 4px;
                    --radius-tabs: 100px;
                    --shadow-inset-card: rgb(255, 255, 255) 0px 0px 24px 0px inset, rgba(0, 0, 0, 0.04) 0px 1px 3px 0px;
                }

                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }

                body {
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
                    background-color: var(--color-fog);
                    color: var(--color-midnight-ink);
                    padding: 40px 24px;
                    font-feature-settings: 'tnum' on;
                    -webkit-font-smoothing: antialiased;
                }

                .container {
                    max-width: 1100px;
                    margin: 0 auto;
                }

                /* Tarjeta principal que ahora contiene todo de forma integrada y limpia */
                .header-card {
                    background: var(--color-paper);
                    padding: 32px 36px;
                    border-radius: var(--radius-cards);
                    border: 1px solid var(--color-lavender-mist);
                    box-shadow: var(--shadow-inset-card);
                    margin-bottom: 24px;
                }

                .eyebrow {
                    font-size: 11px;
                    font-weight: 600;
                    letter-spacing: 0.14em;
                    text-transform: uppercase;
                    color: var(--color-graphite);
                    margin-bottom: 12px;
                    display: block;
                }

                h1 {
                    font-family: 'Lora', Georgia, serif;
                    font-size: 38px;
                    font-weight: 400;
                    color: var(--color-midnight-ink);
                    letter-spacing: -0.05em;
                    line-height: 1.1;
                    margin-bottom: 10px;
                }

                .subtitle {
                    color: var(--color-graphite);
                    font-size: 15px;
                    line-height: 1.5;
                    margin-bottom: 24px;
                }

                /* Barra de controles dentro de la tarjeta */
                .controls-bar {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    flex-wrap: wrap;
                    gap: 16px;
                    padding-top: 20px;
                    border-top: 1px solid var(--color-lavender-mist);
                }

                .indicator-group {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .filter-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    background: var(--color-fog);
                    border: 1px solid var(--color-stone);
                    color: var(--color-charcoal);
                    padding: 4px 10px;
                    border-radius: var(--radius-badges);
                    font-size: 12px;
                    font-weight: 500;
                }

                .filter-badge .badge-val {
                    background: var(--color-midnight-ink);
                    color: var(--color-paper);
                    padding: 2px 7px;
                    border-radius: 3px;
                    font-size: 11px;
                    font-weight: 600;
                }

                /* Pestañas de filtro integradas */
                .tabs-container {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    flex-wrap: wrap;
                }

                .tab-pill {
                    text-decoration: none;
                    padding: 5px 14px;
                    border-radius: var(--radius-tabs);
                    font-size: 13px;
                    font-weight: 450;
                    color: var(--color-graphite);
                    background: var(--color-paper);
                    border: 1px solid var(--color-stone);
                    transition: all 0.15s ease;
                    display: inline-flex;
                    align-items: center;
                }

                .tab-pill:hover {
                    border-color: var(--color-steel);
                    color: var(--color-midnight-ink);
                }

                .tab-pill.activo {
                    background: var(--color-midnight-ink);
                    color: var(--color-paper);
                    border-color: var(--color-midnight-ink);
                    font-weight: 500;
                }

                /* Contenedor de Tabla */
                .table-container {
                    background: var(--color-paper);
                    border-radius: var(--radius-cards);
                    border: 1px solid var(--color-lavender-mist);
                    box-shadow: var(--shadow-inset-card);
                    overflow: hidden;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: left;
                }

                th {
                    background-color: var(--color-fog);
                    color: var(--color-graphite);
                    padding: 14px 18px;
                    font-size: 11.5px;
                    font-weight: 600;
                    letter-spacing: 0.08em;
                    text-transform: uppercase;
                    border-bottom: 1px solid var(--color-lavender-mist);
                }

                td {
                    padding: 14px 18px;
                    border-bottom: 1px solid var(--color-lavender-mist);
                    font-size: 13.5px;
                    vertical-align: middle;
                    color: var(--color-midnight-ink);
                }

                tr:last-child td {
                    border-bottom: none;
                }

                tr:hover {
                    background-color: rgba(246, 247, 248, 0.6);
                }

                /* Evita que el codigo de producto se rompa en dos renglones */
                .code-id {
                    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
                    font-size: 12px;
                    color: var(--color-graphite);
                    background: var(--color-fog);
                    padding: 3px 8px;
                    border-radius: 3px;
                    border: 1px solid var(--color-pearl);
                    white-space: nowrap;
                    display: inline-block;
                }

                .prod-title {
                    font-weight: 600;
                    color: var(--color-midnight-ink);
                }

                /* Sistema de Badges */
                .badge {
                    display: inline-block;
                    padding: 3px 8px;
                    border-radius: var(--radius-badges);
                    font-size: 11.5px;
                    font-weight: 500;
                    letter-spacing: 0.02em;
                    white-space: nowrap;
                }

                .badge-comp {
                    background: var(--badge-comp-bg);
                    color: var(--badge-comp-ink);
                    border: 1px solid var(--badge-comp-ink);
                }

                .badge-mon {
                    background: var(--badge-mon-bg);
                    color: var(--badge-mon-ink);
                    border: 1px solid var(--badge-mon-ink);
                }

                .badge-acc {
                    background: var(--badge-acc-bg);
                    color: var(--badge-acc-ink);
                    border: 1px solid var(--badge-acc-ink);
                }

                .badge-top {
                    background: var(--badge-top-bg);
                    color: var(--badge-top-ink);
                    border: 1px solid var(--badge-top-ink);
                    font-size: 10.5px;
                    font-weight: 600;
                    margin-left: 8px;
                    padding: 1px 6px;
                }

                .price {
                    font-weight: 600;
                    color: var(--color-midnight-ink);
                    white-space: nowrap;
                }

                .currency {
                    font-size: 11px;
                    color: var(--color-steel);
                    margin-left: 3px;
                }

                .stock-pill {
                    display: inline-block;
                    padding: 2px 7px;
                    border-radius: 3px;
                    font-size: 12px;
                    font-weight: 500;
                    background: var(--color-fog);
                    color: var(--color-graphite);
                    border: 1px solid var(--color-stone);
                    white-space: nowrap;
                }

                .desc {
                    color: var(--color-charcoal);
                    font-size: 13px;
                    max-width: 340px;
                    line-height: 1.45;
                }

                .empty-alert {
                    padding: 40px;
                    text-align: center;
                    color: var(--color-graphite);
                    font-size: 14px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <!-- TARJETA PRINCIPAL CON CONTROLES INTEGRADOS ADENTRO -->
                <div class="header-card">
                    <h1>Catalogo Tecnologico</h1>
                    <p class="subtitle">Transformacion directa y filtrado dinamico de XML a HTML con hoja de estilo XSLT</p>
                    
                    <div class="controls-bar">
                        <div class="indicator-group">
                            <div class="filter-badge">
                                Parametro XSLT activo:
                                <span class="badge-val"><xsl:value-of select="$categoriaFiltro" /></span>
                            </div>
                        </div>

                        <!-- Botones de pestañas integrados dentro de la tarjeta -->
                        <div class="tabs-container">
                            <a href="index.php?categoria=Todos">
                                <xsl:attribute name="class">
                                    <xsl:text>tab-pill</xsl:text>
                                    <xsl:if test="$categoriaFiltro = 'Todos'"> activo</xsl:if>
                                </xsl:attribute>
                                Todos
                            </a>
                            <a href="index.php?categoria=Computadoras">
                                <xsl:attribute name="class">
                                    <xsl:text>tab-pill</xsl:text>
                                    <xsl:if test="$categoriaFiltro = 'Computadoras'"> activo</xsl:if>
                                </xsl:attribute>
                                Computadoras
                            </a>
                            <a href="index.php?categoria=Monitores">
                                <xsl:attribute name="class">
                                    <xsl:text>tab-pill</xsl:text>
                                    <xsl:if test="$categoriaFiltro = 'Monitores'"> activo</xsl:if>
                                </xsl:attribute>
                                Monitores
                            </a>
                            <a href="index.php?categoria=Accesorios">
                                <xsl:attribute name="class">
                                    <xsl:text>tab-pill</xsl:text>
                                    <xsl:if test="$categoriaFiltro = 'Accesorios'"> activo</xsl:if>
                                </xsl:attribute>
                                Accesorios
                            </a>
                        </div>
                    </div>
                </div>

                <!-- TABLA DE DATOS -->
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Codigo</th>
                                <th>Producto</th>
                                <th>Categoria</th>
                                <th>Precio Unitario</th>
                                <th>Inventario</th>
                                <th>Especificaciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Iteramos sobre cada producto aplicando el filtro del parametro -->
                            <xsl:for-each select="tienda/producto[$categoriaFiltro = 'Todos' or categoria = $categoriaFiltro]">
                                <tr>
                                    <td>
                                        <span class="code-id"><xsl:value-of select="@id" /></span>
                                    </td>
                                    <td>
                                        <span class="prod-title"><xsl:value-of select="nombre" /></span>
                                        <xsl:if test="@destacado = 'si'">
                                            <span class="badge badge-top">TOP</span>
                                        </xsl:if>
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="categoria = 'Computadoras'">
                                                <span class="badge badge-comp"><xsl:value-of select="categoria" /></span>
                                            </xsl:when>
                                            <xsl:when test="categoria = 'Monitores'">
                                                <span class="badge badge-mon"><xsl:value-of select="categoria" /></span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="badge badge-acc"><xsl:value-of select="categoria" /></span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td class="price">
                                        $<xsl:value-of select="precio" />
                                        <span class="currency"><xsl:value-of select="precio/@moneda" /></span>
                                    </td>
                                    <td>
                                        <span class="stock-pill"><xsl:value-of select="stock" /> u.</span>
                                    </td>
                                    <td class="desc">
                                        <xsl:value-of select="descripcion" />
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>

                    <!-- Mensaje si ningun producto coincide con el filtro -->
                    <xsl:if test="count(tienda/producto[$categoriaFiltro = 'Todos' or categoria = $categoriaFiltro]) = 0">
                        <div class="empty-alert">
                            No se encontraron registros coincidentes con el parametro especificado.
                        </div>
                    </xsl:if>
                </div>
            </div>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
