import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../features/auth/domain/entities/member_entity.dart';

class MemberDropdown extends StatelessWidget {
  final List<MemberEntity> members;
  final MemberEntity? selected;
  final ValueChanged<MemberEntity?> onChanged;
  final String label;

  const MemberDropdown({
    super.key,
    required this.members,
    this.selected,
    required this.onChanged,
    this.label = 'Select Member',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField2<MemberEntity>(
          value: selected,
          decoration: const InputDecoration(),
          hint: const Text('Choose a member'),
          items: members
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text('${m.fullName} (${m.mobileNumber})'),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? 'Please select a member' : null,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
