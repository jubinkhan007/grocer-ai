import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../preferences_controller.dart';
import '../widgets/prefs_widgets.dart';
import '../../../app/app_routes.dart';

const _card = Colors.white;
const _teal = Color(0xFF0C3E3D);
const _bg = Color(0xFFF1F4F6);
const _stroke = Color(0xFF2F6767);

class PrefsHouseholdView extends GetView<PreferencesController> {
  const PrefsHouseholdView({super.key});

  Widget _row(String label, RxInt rx) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1EF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              label == 'Pets'
                  ? Icons.pets_outlined
                  : (label == 'Kids'
                        ? Icons.family_restroom_outlined
                        : Icons.people_alt_outlined),
              color: _teal,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 18))),
          Obx(
            () => Row(
              children: [
                _roundBtn(
                  Icons.remove,
                  onTap: () {
                    if (rx.value > 0) rx.value--;
                  },
                ),
                const SizedBox(width: 14),
                Text(
                  '${rx.value}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 14),
                _roundBtn(Icons.add, onTap: () => rx.value++),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _roundBtn(IconData i, {required VoidCallback onTap}) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(22),
    child: Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _stroke, width: 1.6),
      ),
      child: Icon(i, color: _stroke),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderArc(),
            Expanded(
              child: Obx(() {
                if (c.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pref = c.household;
                if (pref == null) {
                  return const Center(
                    child: Text('Unable to load household preferences.'),
                  );
                }

                // Household numeric fields (Adults, Kids, Pets)
                final adults = c.adultCount;
                final kids = c.kidCount;
                final pets = c.petCount;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pref.title,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF33363E),
                            ),
                      ),
                      const SizedBox(height: 16),
                      _row('Adults', adults),
                      const SizedBox(height: 16),
                      _row('Kids', kids),
                      const SizedBox(height: 16),
                      _row('Pets', pets),
                    ],
                  ),
                );
              }),
            ),

            // ✅ Next button
            Obx(
              () => PrimaryBarButton(
                onTap: () async {
                  await c.submitHousehold();
                  Get.toNamed(Routes.prefsDiet);
                },
                loading: c.loading.value,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
