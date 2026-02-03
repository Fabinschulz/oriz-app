import 'package:flutter/material.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';

extension TransactionCategoryExtension on TransactionCategory {
  Color get color {
    switch (this) {
      case TransactionCategory.mercado:
        return AppColors.food;
      case TransactionCategory.restaurante:
        return AppColors.restaurant;
      case TransactionCategory.cafe:
        return AppColors.coffee;
      case TransactionCategory.gasolina:
        return AppColors.transport;
      case TransactionCategory.transportePublico:
        return AppColors.publicTransport;
      case TransactionCategory.salario:
        return AppColors.income;
      case TransactionCategory.escolaParticular:
        return AppColors.education;
      case TransactionCategory.luz:
        return AppColors.utility;
      case TransactionCategory.aluguel:
        return AppColors.rent;
      case TransactionCategory.shopping:
        return AppColors.leisure;
      case TransactionCategory.natacao:
        return AppColors.leisure;
      case TransactionCategory.parque:
        return AppColors.park;
      case TransactionCategory.viagem:
        return AppColors.travel;
      case TransactionCategory.academia:
        return AppColors.health;
      case TransactionCategory.farmacia:
        return AppColors.pharmacy;
      case TransactionCategory.internet:
        return AppColors.tech;
      case TransactionCategory.presente:
        return AppColors.gift;
      case TransactionCategory.petShop:
        return AppColors.pet;
      default:
        return Colors.grey[400]!;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.mercado:
        return Icons.shopping_basket_rounded;
      case TransactionCategory.restaurante:
        return Icons.restaurant_rounded;
      case TransactionCategory.cafe:
        return Icons.coffee_rounded;
      case TransactionCategory.gasolina:
        return Icons.local_gas_station_rounded;
      case TransactionCategory.transportePublico:
        return Icons.directions_bus_rounded;
      case TransactionCategory.salario:
        return Icons.payments_rounded;
      case TransactionCategory.escolaParticular:
        return Icons.school_rounded;
      case TransactionCategory.luz:
        return Icons.lightbulb_outline_rounded;
      case TransactionCategory.aluguel:
        return Icons.home_work_rounded;
      case TransactionCategory.shopping:
        return Icons.local_mall_rounded;
      case TransactionCategory.natacao:
        return Icons.pool_rounded;
      case TransactionCategory.parque:
        return Icons.forest_rounded;
      case TransactionCategory.viagem:
        return Icons.flight_takeoff_rounded;
      case TransactionCategory.academia:
        return Icons.fitness_center_rounded;
      case TransactionCategory.farmacia:
        return Icons.medical_services_rounded;
      case TransactionCategory.internet:
        return Icons.wifi_rounded;
      case TransactionCategory.presente:
        return Icons.redeem_rounded;
      case TransactionCategory.petShop:
        return Icons.pets_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String get name {
    switch (this) {
      case TransactionCategory.mercado:
        return 'Mercado';
      case TransactionCategory.restaurante:
        return 'Restaurante';
      case TransactionCategory.cafe:
        return 'Café';
      case TransactionCategory.gasolina:
        return 'Combustível';
      case TransactionCategory.transportePublico:
        return 'Transporte Público';
      case TransactionCategory.salario:
        return 'Salário';
      case TransactionCategory.escolaParticular:
        return 'Educação';
      case TransactionCategory.luz:
        return 'Luz/Energia';
      case TransactionCategory.aluguel:
        return 'Aluguel';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.natacao:
        return 'Natação';
      case TransactionCategory.parque:
        return 'Lazer/Parque';
      case TransactionCategory.viagem:
        return 'Viagem';
      case TransactionCategory.academia:
        return 'Academia';
      case TransactionCategory.farmacia:
        return 'Farmácia';
      case TransactionCategory.internet:
        return 'Internet/Tech';
      case TransactionCategory.presente:
        return 'Presente';
      case TransactionCategory.petShop:
        return 'Pet Shop';
      default:
        return 'Outros';
    }
  }
}
