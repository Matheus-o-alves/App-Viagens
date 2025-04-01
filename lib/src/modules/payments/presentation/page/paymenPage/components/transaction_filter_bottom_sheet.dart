import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/domain.dart';
import '../../presentation.dart';


Future<void> showTransactionFilterBottomSheet(
  BuildContext context,
  List<PaymentsTransactionFilterEntity> transactionFilters,
  List<String> selectedKeys,
) async {
  final bloc = context.read<PaymentsBloc>();
  final selected = [...selectedKeys]; 

  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 375),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFDEE0E3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Filter Transactions',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5E646E),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...transactionFilters.map((filter) {
                      final isFixed = filter.isDefault;
                      final isChecked = selected.contains(filter.key);
                      return CheckboxListTile(
                        value: isChecked,
                        activeColor: isFixed
                            ? const Color(0xFF5E646E)
                            : const Color(0xFF39AA35),
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          filter.label,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF37404E),
                          ),
                        ),
                        onChanged: isFixed
                            ? null
                            : (value) {
                                setState(() {
                                  if (value == true) {
                                    selected.add(filter.key);
                                  } else {
                                    selected.remove(filter.key);
                                  }
                                });
                              },
                      );
                    // ignore: unnecessary_to_list_in_spreads
                    }).toList(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  bloc.add(UpdateTransactionFilterKeys(selected));
}
