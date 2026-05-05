import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/customer/customer_bloc.dart';
import 'package:flutter_golaundku/pages/widget/input_customer_dialog_widget.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late TextEditingController inputSearchCustomer;
  @override
  void initState() {
    context.read<CustomerBloc>().add(StartCustomerStream());
    inputSearchCustomer = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inputSearchCustomer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAddSuccess) {
          showSnackBarWidget(context, "Berhasil menambahkan customer baru!");
        } else if (state is CustomerUpdateSuccess) {
          showSnackBarWidget(context, "Berhasil update customer!");
        } else if (state is CustomerDeleteSuccess) {
          showSnackBarWidget(context, "Berhasil menghapus customer!");
        } else if (state is CustomerActionError) {
          showSnackBarWidget(context, state.message);
        } else if (state is CustomerStreamError) {
          showSnackBarWidget(context, "Koneksi realtime bermasalah");
        }
      },
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextField(
            controller: inputSearchCustomer,
            onChanged: (value) {
              context.read<CustomerBloc>().add(SearchCustomer(keyword: value));
            },
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.search),
              fillColor: Theme.of(context).colorScheme.onPrimary,
              hintText: "Cari Customer...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<CustomerBloc, CustomerState>(
            buildWhen: (previous, current) {
              return current is CustomerLoading || current is CustomerLoaded;
            },
            builder: (context, state) {
              if (state is CustomerLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CustomerLoaded) {
                if (state.customerData.isEmpty) {
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
                          "daftar customer kosong!",
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
                    final data = state.customerData[index];
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
                                          InputCustomerDialogWidget(
                                            customerId: data.customerId,
                                            textName: data.name,
                                            textPhone: data.phone,
                                            textAddress: data.address,
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
                                          title: const Text("Hapus Customer"),
                                          content: const Text(
                                            "Apakah kamu yakin ingin menghapus customer ini?",
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
                                                    .read<CustomerBloc>()
                                                    .add(
                                                      DeleteCustomer(
                                                        customerId:
                                                            data.customerId,
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
                                      Icons.phone,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data.phone.toString(),
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
                                      Icons.location_on,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data.address,
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
                  itemCount: state.customerData.length,
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
