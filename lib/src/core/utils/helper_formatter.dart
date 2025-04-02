import 'package:intl/intl.dart';

class PaymentsFormatter {
  PaymentsFormatter._();

  static String formatDate(DateTime date) => 
      DateFormat('dd/MM/yyyy').format(date);
  
  static String formatCurrency(double value) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
}


// Adicione esta classe de utilitário para normalizar textos em toda a aplicação
// utils/text_normalizer.dart
class TextNormalizer {
  static String normalize(String text) {
    return text
        .replaceAll('ã', 'a')
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ç', 'c')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }
  
  // Lista com nomenclatura consistente para categorias
  static List<String> standardCategories = [
    'Transporte',
    'Hospedagem',
    'Alimentacao',
    'Reuniao',
    'Material',
    'Outro'
  ];
  
  // Lista com nomenclatura consistente para métodos de pagamento
  static List<String> standardPaymentMethods = [
    'Cartao Corporativo',
    'Dinheiro',
    'Aplicativo',
    'PIX',
    'Transferencia'
  ];
  
  // Método para garantir que uma categoria seja válida
  static String ensureValidCategory(String category) {
    String normalized = normalize(category);
    if (standardCategories.contains(normalized)) {
      return normalized;
    }
    return standardCategories.first;
  }
  
  // Método para garantir que um método de pagamento seja válido
  static String ensureValidPaymentMethod(String method) {
    String normalized = normalize(method);
    if (standardPaymentMethods.contains(normalized)) {
      return normalized;
    }
    return standardPaymentMethods.first;
  }
}
