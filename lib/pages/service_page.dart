import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/service/service_bloc.dart';
import 'package:flutter_golaundku/pages/widget/input_service_dialog_widget.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late TextEditingController inputSearchLayanan;
  @override
  void initState() {
    context.read<ServiceBloc>().add(StartServiceStream());
    inputSearchLayanan = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inputSearchLayanan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceBloc, ServiceState>(
      listener: (context, state) {
        if (state is ServiceAddSuccess) {
          showSnackBarWidget(context, "Berhasil menambahkan layanan baru!");
        } else if (state is ServiceUpdateSuccess) {
          showSnackBarWidget(context, "Berhasil update layanan!");
        } else if (state is ServiceDeleteSuccess) {
          showSnackBarWidget(context, "Berhasil menghapus layanan!");
        } else if (state is ServiceActionError) {
          showSnackBarWidget(context, state.message);
        } else if (state is ServiceStreamError) {
          showSnackBarWidget(context, "Koneksi realtime bermasalah");
        }
      },
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextField(
            onChanged: (value) {
              context.read<ServiceBloc>().add(SearchService(value));
            },
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.search),
              fillColor: Theme.of(context).colorScheme.onPrimary,
              hintText: "Cari Layanan...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<ServiceBloc, ServiceState>(
            buildWhen: (previous, current) {
              return current is ServiceLoading || current is ServiceLoaded;
            },
            builder: (context, state) {
              if (state is ServiceLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ServiceLoaded) {
                if (state.serviceData.isEmpty) {
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
                          "daftar layanan kosong!",
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
                    final data = state.serviceData[index];
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
                                          InputServiceDialogWidget(
                                            serviceId: data.serviceId,
                                            textName: data.name,
                                            textCategory: data.category,
                                            textPrice: data.price.toString(),
                                            textDuration: data.duration
                                                .toString(),
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
                                          title: const Text("Hapus Layanan"),
                                          content: const Text(
                                            "Apakah kamu yakin ingin menghapus layanan ini?",
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
                                                context.read<ServiceBloc>().add(
                                                  DeleteService(
                                                    serviceId: data.serviceId,
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
                            Text(
                              data.category,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.discount_outlined,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      (data.category.toLowerCase() == "kiloan")
                                          ? "Rp ${data.price} / kg"
                                          : "Rp ${data.price} / (pcs,set)",
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
                                    Icon(
                                      Icons.watch_later_outlined,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${data.duration} Hari",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
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
                  itemCount: state.serviceData.length,
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
