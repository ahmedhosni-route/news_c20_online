import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../manager/layout_provider.dart';


class ArticlesScreen extends StatelessWidget {
  ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            DefaultTabController(
              length: provider.sources.length,
              child: TabBar(
                onTap: (value) {
                  provider.onChangeSource(provider.sources[value]);
                },
                dividerColor: Colors.transparent,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.white,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.white,
                tabs: provider.sources.map((e) {
                  return Tab(text: e.name ?? "");
                }).toList(),
              ),
            ),

            Expanded(
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
                          imageUrl:  provider.articles[index].urlToImage ??"",
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.red,),
                        ),
                        // Image.network(provider.articles[index].urlToImage ?? ""),
                        SizedBox(height: 12),
                        Text(
                          provider.articles[index].title ?? "",
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
                                "By : ${provider.articles[index].author ?? ""}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Text(
                              provider.articles[index].publishedAt?.substring(0, 10) ?? "",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: provider.articles.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
