// DataTable(
//     dataRowHeight: DataRowHeight,
//     headingRowHeight: HeadingRowHeight,
//     columns: screenSize.width < 900 ?
//     <DataColumn>[
//       DataColumn(
//         label: Expanded(
//           child: Text(
//             'Client',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//       DataColumn(
//         label: Expanded(
//           child: Text(
//             "Actions",
//             style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     ]:
//     <DataColumn>[
//       DataColumn(
//         label: Expanded(
//           child: Text(
//             'Client',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//       DataColumn(
//         label: Expanded(
//           child: Text(
//             'Date de transaction',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//       DataColumn(
//         label: Expanded(
//           child: Text(
//             'Type',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//       // DataColumn(
//       //   label: Expanded(
//       //     child: Text(
//       //       'Client',
//       //       style: TextStyle(
//       //           fontStyle: FontStyle.italic,
//       //           fontWeight: FontWeight.bold
//       //       ),
//       //     ),
//       //   ),
//       // ),
//       DataColumn(
//         label: Expanded(
//           child: Text(
//             "Actions",
//             style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     ],
//     rows:
//     transations.map<DataRow>((t) => DataRow(
//       cells:  screenSize.width < 900 ?
//       <DataCell>[
//         DataCell(Row(
//           children: [
//             t.Type == true ?
//             Icon(Icons.arrow_circle_right_outlined, size: 22, color: Colors.green,) :
//             Icon(Icons.arrow_circle_left_outlined, size: 22, color: Colors.red,),
//             SizedBox(width: 9,),
//             Text( "${t.client}")
//           ],
//         )),
//         DataCell(Row(
//           children: [
//             ShowButton(
//                 msg:"•Visualisation Les détails Transaction",
//                 onPressed: (){
//                   showDialog(context: context, builder: (context) =>
//                       BsModal(
//                           context: context,
//                           dialog: BsModalDialog(
//                             size: BsModalSize.md,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             child: BsModalContent(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               children: [
//                                 BsModalContainer(
//                                   //title:
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   actions: [
//                                     Text('Transaction N°: ${t.id_tran}',
//                                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                     BsButton(
//                                       style: BsButtonStyle.outlinePrimary,
//                                       label: Text('Fermer'),
//                                       prefixIcon: Icons.close,
//                                       onPressed: () {
//                                         initData();
//                                         Navigator.pop(context);
//                                       },
//                                     )
//                                   ],
//                                   //closeButton: true,
//                                 ),
//                               /*BsModalContainer(title: Text('Transaction N°: ${t.id_tran}',style: TextStyle(
//                                   fontWeight: FontWeight.bold, color: Colors.grey
//                                 ),), closeButton: true),*/
//                                 BsModalContainer(
//                                  child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: 170,
//                                           height: 120,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                               border: Border.all(color: Colors.grey),
//                                               color: Colors.grey[200],
//                                               image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage('${HOST}/media/${t.image.toString()}')
//                                               )
//                                           ),
//                                         ),
//                                         SizedBox(width: 8,),
//                                         Expanded(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Date:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text(" ${DateFormat('dd/MM/yyyy').format(t.date!)}"),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Type Transaction:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text(" ${t.Type == true ? "Entrer" : "Sortie"}"),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Montant:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text(" ${t.montant} "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Mode reglement:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text(" ${t.Mode_reglement} "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Id contrat:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text(" ${t.id_contrat}  "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Client:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text("${t.client} "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Description:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text(" ${t.description}  "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text("Acteur:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(height: 4,),
//                                                     Text("${t.mail_admin} ",
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           color: Colors.black
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             )
//                                         )
//                                       ]
//                                   ),
//                                 ),
//                                 BsModalContainer(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   actions: [
//                                     //Navigator.pop(context);
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )));
//                 }
//             ),
//             SizedBox(width: 10,),
//
//             // DeleteButton(
//             //   onPressed: () async{
//             //     if (await confirm(
//             //       context,
//             //       title: const Text('Confirmation'),
//             //       content: const Text('Souhaitez-vous supprimer ?'),
//             //       textOK: const Text('Oui'),
//             //       textCancel: const Text('Non'),
//             //     )) {
//             //
//             //       delete(t.id_tran.toString());
//             //     }
//             //
//             //   },
//             // ),
//
//           ],
//         ))
//
//       ]:
//       <DataCell>[
//         DataCell(Row(
//           children: [
//             t.Type == true ?
//             Icon(Icons.arrow_circle_right_outlined, size: 22, color: Colors.green,) :
//             Icon(Icons.arrow_circle_left_outlined, size: 22, color: Colors.red,),
//             SizedBox(width: 9,),
//             Text( "${t.client}")
//           ],
//         )),
//         DataCell(Text(DateFormat('dd/MM/yyyy').format(t.date!))),
//         DataCell(
//             Text(
//                 t.Type == true ? "Entrer" : "Sortie"
//             )
//         ),
//         //DataCell(Text(t.client!)),
//         // DataCell(Text(r.motif_annulation == null ? "-" : r.motif_annulation.toString())),
//         DataCell(Row(
//           children: [
//             ShowButton(
//                 msg:"•Visualisation Les détails Transaction",
//                 onPressed: (){
//                   showDialog(context: context, builder: (context) =>
//                       BsModal(
//                           context: context,
//                           dialog: BsModalDialog(
//                             size: BsModalSize.md,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             child: BsModalContent(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               children: [
//                                 BsModalContainer(
//                                   //title:
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   actions: [
//                                     Text('Transaction N°: ${t.id_tran}',
//                                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                                     BsButton(
//                                       style: BsButtonStyle.outlinePrimary,
//                                       label: Text('Fermer'),
//                                      // prefixIcon: Icons.close,
//                                       onPressed: () {
//                                         initData();
//                                         Navigator.pop(context);
//                                       },
//                                     )
//                                   ],
//                                   //closeButton: true,
//
//                                 ),
//                                 /*BsModalContainer(title: Text('Transaction N°: ${t.id_tran}',style: TextStyle(
//                                     fontWeight: FontWeight.bold, color: Colors.grey
//                                 ),), closeButton: true),*/
//                                 BsModalContainer(
//                                   child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: 170,
//                                           height: 120,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                               border: Border.all(color: Colors.grey),
//                                               color: Colors.grey[200],
//                                               image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage('${HOST}/media/${t.image.toString()}')
//                                               )
//                                           ),
//                                         ),
//                                         SizedBox(width: 8,),
//                                         Expanded(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Date:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text(" ${DateFormat('dd/MM/yyyy').format(t.date!)}"),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Type Transaction:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text(" ${t.Type == true ? "Entrer" : "Sortie"}"),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Montant:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text(" ${t.montant} "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Mode reglement:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text(" ${t.Mode_reglement} "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Id contrat:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text(" ${t.id_contrat}  "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Client:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text("${t.client} "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Description:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text(" ${t.description}  "),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 4,),
//                                                 Row(
//                                                   children: [
//                                                     Text("Acteur:" ,style: TextStyle(
//                                                         fontWeight: FontWeight.bold, color:Colors.grey
//                                                     ),),
//                                                     SizedBox(width: 9,),
//                                                     Text("${t.mail_admin} ",
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           color: Colors.black
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             )
//                                         )
//                                       ]
//                                   ),
//                                 ),
//                                 BsModalContainer(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   actions: [
//                                     //Navigator.pop(context);
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )));
//                 }
//             ),
//             SizedBox(width: 10,),
//             // DeleteButton(
//             //   onPressed: () async{
//             //     if (await confirm(
//             //       context,
//             //       title: const Text('Confirmation'),
//             //       content: const Text('Souhaitez-vous supprimer ?'),
//             //       textOK: const Text('Oui'),
//             //       textCancel: const Text('Non'),
//             //     )) {
//             //
//             //       delete(t.id_tran.toString());
//             //     }
//             //
//             //   },
//             // ),
//           ],
//         ))
//       ],
//     )).toList()
// ),]