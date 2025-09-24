import 'dart:io';
import '../lib/utils/app_constants.dart';

void main() {
  print('=== TEST IMMAGINI ===');
  
  // Test se tutti i file esistono
  for (int i = 0; i < BeverageAssets.allImages.length; i++) {
    String path = BeverageAssets.allImages[i];
    String filePath = path.replaceFirst('assets/', '');
    File file = File(filePath);
    
    print('[$i] $path - Esiste: ${file.existsSync()}');
  }
  
  print('=== FINE TEST ===');
}