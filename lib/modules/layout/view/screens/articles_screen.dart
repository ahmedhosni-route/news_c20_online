import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_c20_online/modules/layout/view/cubit/cubit.dart';
import 'package:news_c20_online/modules/layout/view/cubit/states.dart';

import '../../../../core/theme/app_colors.dart';

class ArticlesScreen extends StatelessWidget {
  ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<LayoutCubit, LayoutState>(
          buildWhen: (previous, current) {
            return current is GetSourceErrorState ||
                current is GetSourceLoadingState ||
                current is GetSourceSuccessState;
          },
          builder: (context, state) {
            var cubit = BlocProvider.of<LayoutCubit>(context);
            if (state is GetSourceSuccessState) {
              return DefaultTabController(
                length: cubit.sources.length,
                child: TabBar(
                  onTap: (value) {
                    cubit.onChangeSource(cubit.sources[value]);
                  },
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppColors.white,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white,
                  tabs: cubit.sources.map((e) {
                    return Tab(text: e.name ?? "");
                  }).toList(),
                ),
              );
            } else if (state is GetSourceLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetSourceErrorState) {
              return Center(
                child: Text(state.error, style: TextStyle(color: Colors.white)),
              );
            } else {
              return SizedBox();
            }
          },
        ),

        BlocBuilder<LayoutCubit, LayoutState>(
          buildWhen: (previous, current) {
            return current is GetNewsSuccessState ||
                current is GetNewsLoadingState ||
                current is GetNewsErrorState;
          },
          builder: (context, state) {
            var cubit = BlocProvider.of<LayoutCubit>(context);
            if (state is GetNewsSuccessState) {
              return Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.white),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: cubit.articles[index].urlToImage ?? "",
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, color: Colors.red),
                          ),
                          // Image.network(cubit.articles[index].urlToImage ?? ""),
                          SizedBox(height: 12),
                          Text(
                            cubit.articles[index].title ?? "",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "By : ${cubit.articles[index].author ?? ""}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Text(
                                cubit.articles[index].publishedAt?.substring(
                                      0,
                                      10,
                                    ) ??
                                    "",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: cubit.articles.length,
                ),
              );
            } else if (state is GetNewsLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetNewsErrorState) {
              return Center(
                child: Text(state.error, style: TextStyle(color: Colors.white)),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}
