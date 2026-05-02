import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/discount/discount_bloc.dart';
import 'package:flutter_golaundku/pages/widget/input_discount_dialog_widget.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  @override
  void initState() {
    context.read<DiscountBloc>().add(StartDiscountStream());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscountBloc, DiscountState>(
      listener: (context, state) {
        if (state is DiscountAddSuccess) {
          showSnackBarWidget(context, "Berhasil menambahkan discount baru!");
        } else if (state is DiscountUpdateSuccess) {
          showSnackBarWidget(context, "Berhasil update discount!");
        } else if (state is DiscountDeleteSuccess) {
          showSnackBarWidget(context, "Berhasil menghapus discount!");
        } else if (state is DiscountActionError) {
          showSnackBarWidget(context, state.message);
        } else if (state is DiscountStreamError) {
          showSnackBarWidget(context, "Koneksi realtime bermasalah");
        }
      },
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          const SizedBox(height: 20),
          BlocBuilder<DiscountBloc, DiscountState>(
            buildWhen: (previous, current) {
              return current is DiscountLoading || current is DiscountLoaded;
            },
            builder: (context, state) {
              if (state is DiscountLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DiscountLoaded) {
                if (state.discountData.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Theme.of(context).colorScheme.error,
                          size: 100,
                        ),
                        Text(
                          "daftar discount kosong!",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = state.discountData[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          InputDiscountDialogWidget(
                                            discountId: data.discountId,
                                            textName: data.name,
                                            textType: data.type,
                                            textValue: data.value.toString(),
                                            isActive: data.active,
                                          ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Hapus Discount"),
                                          content: const Text(
                                            "Apakah kamu yakin ingin menghapus discount ini?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text("Batal"),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context
                                                    .read<DiscountBloc>()
                                                    .add(
                                                      DeleteDiscount(
                                                        discountId:
                                                            data.discountId,
                                                      ),
                                                    );
                                              },
                                              style: FilledButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                              child: const Text("Hapus"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.discount,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data.type == "fixed"
                                          ? "Rp ${data.value}"
                                          : "${data.value}%",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Status:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data.active == true
                                          ? "Aktif"
                                          : "Tidak Aktif",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: data.active == true
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: state.discountData.length,
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  void showSnackBarWidget(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: Duration(seconds: 1),
        content: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
