/// Kalkulator Digital — Aplikasi NEXA.
///
/// Operasi yang didukung:
/// 1. Penjumlahan (+)
/// 2. Pengurangan (−)
/// 3. Perkalian (×)
/// 4. Pembagian (÷)
/// 5. Kuadrat (x²)
/// 6. Akar kuadrat (√x)
/// 7. Clear (C) — reset semua
/// 8. Backspace (⌫) — hapus karakter terakhir
/// 9. Persen (%)
/// 10. Tanda positif/negatif (±)
///
/// Penanganan error:
/// - Pembagian dengan nol → "Tidak terdefinisi"
/// - Akar kuadrat bilangan negatif → "Nilai tidak valid"
/// - Input kosong → diabaikan
///
/// State management: setState sederhana.
/// Logika: Menyimpan operand pertama, operator, dan operand kedua,
/// lalu menghitung saat tombol "=" ditekan.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // ─── State Kalkulator ──────────────────────────────────
  /// Teks yang ditampilkan di layar utama (angka saat ini / hasil).
  String _display = '0';

  /// Ekspresi yang ditampilkan di baris atas (riwayat operasi).
  String _expression = '';

  /// Operand pertama (bilangan sebelum operator).
  double? _firstOperand;

  /// Operator yang sedang aktif (+, −, ×, ÷).
  String? _operator;

  /// Apakah input berikutnya akan mengganti display (setelah operator/hasil).
  bool _shouldResetDisplay = false;

  /// Apakah hasil baru saja dihitung (untuk mencegah double-equals).
  bool _justCalculated = false;

  // ─── Aksi Tombol ───────────────────────────────────────

  /// Input angka (0-9) dan titik desimal.
  void _inputNumber(String value) {
    setState(() {
      if (_justCalculated) {
        // Setelah "=", mulai kalkulasi baru
        _expression = '';
        _firstOperand = null;
        _operator = null;
        _justCalculated = false;
        _display = value == '.' ? '0.' : value;
        return;
      }

      if (_shouldResetDisplay) {
        _display = value == '.' ? '0.' : value;
        _shouldResetDisplay = false;
      } else {
        if (value == '.' && _display.contains('.')) return; // Cegah double titik
        if (_display == '0' && value != '.') {
          _display = value; // Ganti leading zero
        } else {
          _display += value;
        }
      }
    });
  }

  /// Input operator (+, −, ×, ÷).
  void _inputOperator(String op) {
    setState(() {
      final currentValue = double.tryParse(_display);
      if (currentValue == null) return;

      if (_firstOperand != null && _operator != null && !_shouldResetDisplay) {
        // Chain operation: hitung dulu operasi sebelumnya
        _calculate();
        _firstOperand = double.tryParse(_display);
      } else {
        _firstOperand = currentValue;
      }

      _operator = op;
      _expression = '${_formatNumber(_firstOperand!)} $op';
      _shouldResetDisplay = true;
      _justCalculated = false;
    });
  }

  /// Hitung hasil (tombol "=").
  void _calculate() {
    setState(() {
      if (_firstOperand == null || _operator == null) return;

      final secondOperand = double.tryParse(_display);
      if (secondOperand == null) return;

      double? result;
      String error = '';

      switch (_operator) {
        case '+':
          result = _firstOperand! + secondOperand;
          break;
        case '−':
          result = _firstOperand! - secondOperand;
          break;
        case '×':
          result = _firstOperand! * secondOperand;
          break;
        case '÷':
          if (secondOperand == 0) {
            error = 'Tidak terdefinisi';
          } else {
            result = _firstOperand! / secondOperand;
          }
          break;
      }

      _expression =
          '${_formatNumber(_firstOperand!)} $_operator ${_formatNumber(secondOperand)} =';

      if (error.isNotEmpty) {
        _display = error;
      } else if (result != null) {
        _display = _formatNumber(result);
      }

      _firstOperand = result;
      _operator = null;
      _shouldResetDisplay = true;
      _justCalculated = true;
    });
  }

  /// Operasi kuadrat (x²).
  void _square() {
    setState(() {
      final value = double.tryParse(_display);
      if (value == null) return;

      final result = value * value;
      _expression = '(${_formatNumber(value)})² =';
      _display = _formatNumber(result);
      _firstOperand = result;
      _operator = null;
      _shouldResetDisplay = true;
      _justCalculated = true;
    });
  }

  /// Operasi akar kuadrat (√x).
  void _squareRoot() {
    setState(() {
      final value = double.tryParse(_display);
      if (value == null) return;

      if (value < 0) {
        _expression = '√(${_formatNumber(value)})';
        _display = 'Nilai tidak valid';
        _shouldResetDisplay = true;
        _justCalculated = true;
        return;
      }

      final result = math.sqrt(value);
      _expression = '√(${_formatNumber(value)}) =';
      _display = _formatNumber(result);
      _firstOperand = result;
      _operator = null;
      _shouldResetDisplay = true;
      _justCalculated = true;
    });
  }

  /// Persen: konversi nilai saat ini menjadi persentase.
  void _percent() {
    setState(() {
      final value = double.tryParse(_display);
      if (value == null) return;

      final result = value / 100;
      _expression = '${_formatNumber(value)}%';
      _display = _formatNumber(result);
      _shouldResetDisplay = true;
    });
  }

  /// Toggle tanda positif/negatif (±).
  void _toggleSign() {
    setState(() {
      if (_display == '0' || _display == 'Tidak terdefinisi' || _display == 'Nilai tidak valid') {
        return;
      }
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = '-$_display';
      }
    });
  }

  /// Clear semua (C).
  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _shouldResetDisplay = false;
      _justCalculated = false;
    });
  }

  /// Hapus karakter terakhir (⌫).
  void _backspace() {
    setState(() {
      if (_justCalculated ||
          _display == 'Tidak terdefinisi' ||
          _display == 'Nilai tidak valid') {
        _clear();
        return;
      }
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        if (_display == '-') _display = '0';
      } else {
        _display = '0';
      }
    });
  }

  /// Format angka: hilangkan .0 untuk bilangan bulat, batasi desimal.
  String _formatNumber(double number) {
    if (number.isInfinite || number.isNaN) {
      return 'Error';
    }
    // Bilangan bulat → tanpa desimal
    if (number == number.truncateToDouble() && number.abs() < 1e15) {
      return number.toInt().toString();
    }
    // Bilangan desimal → maksimal 10 digit signifikan
    String formatted = number.toStringAsFixed(10);
    // Hapus trailing zeros
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  // ─── Build ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          // ─── Display Area ──────────────────────────
          Expanded(
            flex: 2,
            child: _buildDisplay(),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ─── Tombol Fungsi Khusus ──────────────────
          _buildSpecialRow(),

          const SizedBox(height: AppSpacing.sm),

          // ─── Keypad Utama ──────────────────────────
          Expanded(
            flex: 5,
            child: _buildKeypad(),
          ),

          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }

  /// Area display: ekspresi (atas) dan angka utama (bawah).
  Widget _buildDisplay() {
    // Ukuran font adaptif berdasarkan panjang teks
    double fontSize = 48;
    if (_display.length > 12) {
      fontSize = 32;
    } else if (_display.length > 8) {
      fontSize = 38;
    }

    final bool isError = _display == 'Tidak terdefinisi' || _display == 'Nilai tidak valid' || _display == 'Error';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Ekspresi / riwayat operasi
          if (_expression.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                _expression,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neonGreen.withValues(alpha: 0.7),
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Angka utama / hasil
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w300,
                color: isError ? AppColors.error : AppColors.textPrimary,
                letterSpacing: -0.5,
                height: 1.2,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Baris tombol fungsi khusus: x², √, %, ±
  Widget _buildSpecialRow() {
    final items = [
      _SpecialBtn(label: 'x²', onTap: _square),
      _SpecialBtn(label: '√x', onTap: _squareRoot),
      _SpecialBtn(label: '%', onTap: _percent),
      _SpecialBtn(label: '±', onTap: _toggleSign),
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _buildSpecialButton(item.label, item.onTap),
          ),
        );
      }).toList(),
    );
  }

  /// Grid keypad utama (angka, operator, C, ⌫, =).
  Widget _buildKeypad() {
    // Layout 5 baris × 4 kolom
    final rows = [
      ['C', '⌫', '÷', '×'],
      ['7', '8', '9', '−'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '='],
      ['00', '0', '.', '='],
    ];

    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.asMap().entries.map((entry) {
              final label = entry.value;

              // Tombol "=" di baris 4 dan 5 (kolom terakhir) → gabung jadi satu
              // Baris ke-4 (index 3): tampilkan "="
              // Baris ke-5 (index 3): skip (sudah tergabung)
              if (label == '=' && rows.indexOf(row) == 4) {
                return const Expanded(child: SizedBox()); // placeholder kosong, "=" sudah merged
              }

              // Tentukan apakah tombol "=" di baris ke-4 harus tall
              final isEquals = label == '=' && rows.indexOf(row) == 3;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: isEquals
                      ? _buildTallEqualsButton()
                      : _buildButton(label),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Button Builders
  // ═══════════════════════════════════════════════════════

  /// Tombol standar pada keypad.
  Widget _buildButton(String label) {
    final isOperator = ['+', '−', '×', '÷'].contains(label);
    final isClear = label == 'C';
    final isBackspace = label == '⌫';
    final isActiveOp = isOperator && _operator == label && _shouldResetDisplay;

    Color bgColor;
    Color textColor;

    if (isActiveOp) {
      bgColor = AppColors.neonGreen;
      textColor = AppColors.textOnPrimary;
    } else if (isOperator) {
      bgColor = AppColors.neonGreen.withValues(alpha: 0.15);
      textColor = AppColors.neonGreen;
    } else if (isClear) {
      bgColor = AppColors.error.withValues(alpha: 0.15);
      textColor = AppColors.error;
    } else if (isBackspace) {
      bgColor = AppColors.surfaceLight;
      textColor = AppColors.textSecondary;
    } else {
      bgColor = AppColors.surfaceLight;
      textColor = AppColors.textPrimary;
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: () => _handleButtonTap(label),
        borderRadius: BorderRadius.circular(AppRadius.md),
        splashColor: AppColors.neonGreen.withValues(alpha: 0.15),
        child: Center(
          child: label == '⌫'
              ? Icon(Icons.backspace_outlined, color: textColor, size: 22)
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: isOperator ? 24 : 22,
                    fontWeight: isOperator ? FontWeight.w500 : FontWeight.w400,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }

  /// Tombol "=" tinggi (2 baris).
  Widget _buildTallEqualsButton() {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Material(
          color: AppColors.neonGreen,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: _calculate,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              height: double.infinity,
              child: const Center(
                child: Text(
                  '=',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Tombol fungsi khusus (x², √, %, ±).
  Widget _buildSpecialButton(String label, VoidCallback onTap) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        splashColor: AppColors.neonGreen.withValues(alpha: 0.1),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.border,
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.neonGreen.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }

  /// Routing aksi tombol berdasarkan label.
  void _handleButtonTap(String label) {
    switch (label) {
      case 'C':
        _clear();
        break;
      case '⌫':
        _backspace();
        break;
      case '+':
      case '−':
      case '×':
      case '÷':
        _inputOperator(label);
        break;
      case '=':
        _calculate();
        break;
      case '.':
      case '0':
      case '00':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        if (label == '00') {
          _inputNumber('0');
          _inputNumber('0');
        } else {
          _inputNumber(label);
        }
        break;
    }
  }
}

class _SpecialBtn {
  const _SpecialBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
}
