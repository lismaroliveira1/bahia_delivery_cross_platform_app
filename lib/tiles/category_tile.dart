import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ListCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoading) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        if (model.categoryDataList.length == 0) {
          model.updateCategory();
          return Container(
            height: 0,
            width: 0,
          );
        } else {
          return Container(
            margin: EdgeInsets.all(8),
            height: 120.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: model.categoryDataList.map((doc) {
                return Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          height: 75,
                          width: 75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc.image,
                              fit: BoxFit.fill,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          doc.title,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }
      }
    });
  }
}
