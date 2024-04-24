import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:winhealth_admin_v2/models/partner.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class PartnerCard extends StatelessWidget {
  final Partner partner;
  final bool isSelected;
  const PartnerCard({
    super.key,
    required this.partner,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? primaryColor2 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // ignore: prefer_const_constructors
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "${BaseService.BASE_URL}/assets/${partner.image}",
              height: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Name: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "${partner.name}",
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Added on: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  partner.dateCreated.toString().split(".").first,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
