<?php

/**
 * Practica: Transformacion XML a HTML mediante XSLT en PHP
 */

// 1. CARGA DE ARCHIVOS XML Y XSL MEDIANTE DOMDocument
$rutaXml = __DIR__ . '/productos.xml';
$rutaXsl = file_exists(__DIR__ . '/plantilla.xslt') ? __DIR__ . '/plantilla.xslt' : __DIR__ . '/plantilla.xsl';

$xmlDoc = new DOMDocument();
$xmlDoc->load($rutaXml);

$xslDoc = new DOMDocument();
$xslDoc->load($rutaXsl);

// 2. CONFIGURAR EL PROCESADOR XSLT (XSLTProcessor)
$procesador = new XSLTProcessor();
$procesador->importStyleSheet($xslDoc);

// 3. PASAR EL PARaMETRO A LA TRANSFORMACIoN XSLT
$categoriaSeleccionada = isset($_GET['categoria']) ? trim($_GET['categoria']) : 'Todos';
$procesador->setParameter('', 'categoriaFiltro', $categoriaSeleccionada);

// 4. EJECUTAR LA TRANSFORMACIoN DE XML A HTML
// Toda la estructura de diseño, tarjeta y botones de filtro
// es generada directamente por la hoja de estilos XSLT
echo $procesador->transformToXML($xmlDoc);
