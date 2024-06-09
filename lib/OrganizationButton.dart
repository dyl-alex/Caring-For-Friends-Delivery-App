import 'package:flutter/material.dart';
import 'Organization_Original.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'globals.dart';
import 'models/Organization.dart';

class OrganizationButton extends StatelessWidget {
  const OrganizationButton({
    super.key,
    required this.organization,
  });

  final Organization organization;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        elevation: 6.0,
        //side: BorderSide(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      ),
      onPressed: () {
        currentOrg = organization;
        print(currentOrg.organizationName);
        context.push("/home"); //TODO: change to goNamed
      }, //TODO: Add the redirect once the button is tapped
      child: SvgPicture.network(organization.thumbnail,
        semanticsLabel: organization.organizationName,
        height: 100,
        width: 100,),
    );
  }
}