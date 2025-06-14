/**
 * Función para descargar el comprobante de pago como archivo PDF
 * Genera un archivo PDF con todos los detalles de la transacción
 */
function descargarComprobante() {
    // Verificar si jsPDF está cargado correctamente (versión UMD)
    if (!window.jspdf || !window.jspdf.jsPDF) {
        alert('Error: La librería PDF no está cargada. Por favor, recarga la página.');
        return;
    }

    // Obtener la clase jsPDF desde el global UMD
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();

    // Obtener los elementos del DOM para extraer la información
    const estadoBadge = document.querySelector('.estado-badge');
    const detalleTable = document.querySelector('.detalle-table');
    
    // Extraer los datos de la tabla
    const filas = detalleTable ? detalleTable.querySelectorAll('tr') : [];
    const datos = {};
    
    filas.forEach(fila => {
        const celdas = fila.querySelectorAll('td');
        if (celdas.length >= 2) {
            const etiqueta = celdas[0].textContent.trim();
            const valor = celdas[1].textContent.trim();
            datos[etiqueta] = valor;
        }
    });

    // Crear el documento PDF
    doc.setFont("helvetica");
    
    // Título principal
    doc.setFontSize(20);
    doc.setTextColor(107, 79, 58); // Color #6B4F3A
    doc.text("COMPROBANTE DE PAGO", 105, 30, { align: "center" });
    
    // Subtítulo
    doc.setFontSize(14);
    doc.setTextColor(161, 126, 98); // Color #A17E62
    doc.text("BECS FRUTOS SECOS Y CONDIMENTOS", 105, 40, { align: "center" });
    
    // Línea separadora
    doc.setDrawColor(231, 174, 120); // Color #e7ae78
    doc.setLineWidth(0.5);
    doc.line(20, 50, 190, 50);
    
    // Estado de la transacción
    doc.setFontSize(16);
    doc.setTextColor(107, 79, 58);
    doc.text("Estado de la Transacción:", 20, 70);
    
    // Color del estado según el resultado
    let estadoColor;
    const estado = estadoBadge ? estadoBadge.textContent.trim() : 'No disponible';
    if (estado === 'ACEPTADO') {
        estadoColor = [76, 175, 80]; // Verde
    } else if (estado === 'RECHAZADO') {
        estadoColor = [244, 67, 54]; // Rojo
    } else {
        estadoColor = [255, 152, 0]; // Naranja
    }
    
    doc.setTextColor(estadoColor[0], estadoColor[1], estadoColor[2]);
    doc.setFontSize(14);
    doc.text(estado, 20, 80);
    
    // Resetear color para el resto del contenido
    doc.setTextColor(107, 79, 58);
    
    // Información de la transacción
    doc.setFontSize(12);
    let yPosition = 100;
    
    const informacion = [
        { label: "Fecha y Hora:", value: datos['Fecha y Hora:'] || 'No disponible' },
        { label: "Número de Tarjeta:", value: datos['Número de Tarjeta:'] || 'No disponible' },
        { label: "Tipo de Pago:", value: datos['Tipo de Pago:'] || 'No disponible' },
        { label: "Monto Pagado:", value: datos['Monto Pagado:'] || 'No disponible' },
        { label: "Código de Autorización:", value: datos['Código de Autorización:'] || 'No disponible' },
        { label: "Número de Orden:", value: datos['Número de Orden:'] || 'No disponible' }
    ];
    
    informacion.forEach(item => {
        // Etiqueta
        doc.setFont("helvetica", "bold");
        doc.setTextColor(107, 79, 58);
        doc.text(item.label, 20, yPosition);
        
        // Valor
        doc.setFont("helvetica", "normal");
        doc.setTextColor(113, 77, 55); // Color #714D37
        doc.text(item.value, 20, yPosition + 8);
        
        yPosition += 20;
    });
    
    // Línea separadora final
    doc.setDrawColor(231, 174, 120);
    doc.setLineWidth(0.5);
    doc.line(20, yPosition + 10, 190, yPosition + 10);
    
    // Fecha de descarga
    doc.setFontSize(10);
    doc.setTextColor(161, 126, 98);
    doc.text(`Fecha de descarga: ${new Date().toLocaleString('es-CL')}`, 20, yPosition + 25);
    
    // Pie de página
    doc.setFontSize(8);
    doc.setTextColor(128, 128, 128);
    doc.text("Este documento es un comprobante oficial de la transacción realizada.", 105, 270, { align: "center" });
    
    // Generar nombre del archivo
    const fecha = new Date().toISOString().split('T')[0];
    const nombreArchivo = `comprobante_pago_${fecha}.pdf`;
    
    // Descargar el PDF
    doc.save(nombreArchivo);
} 