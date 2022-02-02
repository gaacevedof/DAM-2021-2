import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'empresa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Base de datos con SQlite",
      home: const HomePage("Base de datos empresarial"),
    );
  }
}

class HomePage extends StatefulWidget{
  final String titulo;
  const HomePage(this.titulo);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  TextEditingController c4 = TextEditingController();
  TextEditingController c5 = TextEditingController();
  TextEditingController c6 = TextEditingController();

  bool filtro_visible = false;
  bool nuevo = false;
  bool mod = false;

  bool c = false;
  bool dm = false;
  bool fs = false;

  bool cn = false;
  bool dmn = false;
  bool fsn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: GestureDetector(
        onTap: () => setState(() {nuevo = false; cn = false; dmn = false; fsn = false; mod = false;}
        ),
        child: Padding(padding: EdgeInsets.all(12),
          child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  children:[
                    // Creación de entrada de búsqueda y submenú del filtro
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                              controller: c6,
                              decoration: const InputDecoration(
                                  hintText: 'Buscar'
                              ),
                              onChanged: (text) => setState(() {

                              }),
                            )
                        ),
                        const SizedBox(width: 20.0),
                        OutlinedButton(
                          onPressed: () => setState(() {
                            filtro_visible = !filtro_visible;
                          }),
                          child: const Icon(Icons.filter_alt_sharp,color: Colors.black),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: filtro_visible ? Colors.white10 : Colors.white
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // Creación de la lista de empresas
                    Expanded(
                      child: FutureBuilder(
                          future: DB.instance.retrieve_limit(c6.text),
                          builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                            if(!snapshot.hasData) return  const Center(child: CircularProgressIndicator());
                            return snapshot.data!.isEmpty ?
                            const Center(child: Text("Adicione alguna empresa.")) :
                            ListView(children: snapshot.data!.map((e) => tarjeta(e)).toList());
                          }),
                    )
                  ],
                ),

                filtro_visible ? filtro() : SizedBox(),
              ]

          ),
        ),
      ),

        floatingActionButton: Stack(
          alignment: Alignment.bottomRight,
            children: [
              FloatingActionButton(
                onPressed: () => setState(() {
                  nuevo = true;
                }),
                child: const Icon(Icons.add),
              ),
              nuevo ? nueva_empresa() : SizedBox(),
          ]
        ),
    );
  }

  // Tarjeta que muestra la información de la empresa
  Widget tarjeta(Empresa emp){
    return Card(
        child: Expanded(
          child: ExpansionTile(
            title: Text(emp.nombre),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Telefono: ${emp.telefono}'),
                    Text('email: ${emp.email}'),
                    Text('url: ${emp.url}'),
                    Text('productos: ${emp.productos}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(onPressed: () async =>  modificar(emp), child: const Text("Modificar")),
                        const SizedBox(width: 8,),
                        ElevatedButton(
                            onPressed: () async {
                              DB.instance.delete(emp.nombre);
                              setState(() {});
                            },
                            child: const Icon(Icons.delete)),
                        const SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Widget nueva_empresa(){

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color:Colors.black)
        ),
        width: 300,
        height: 300,
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Column(
            children: [
              TextField(
                controller: c1,
                decoration: const InputDecoration(
                    hintText: 'Nombre',
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10)
                ),
              ),
              TextField(
                controller: c2,
                decoration: const InputDecoration(
                    hintText: 'Teléfono',
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10)
                ),
              ),
              TextField(
                controller: c3,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10)
                ),
              ),
              TextField(
                controller: c4,
                decoration: const InputDecoration(
                    hintText: 'url',
                    isDense: true
                ),
              ),
              TextField(
                controller: c5,
                decoration: const InputDecoration(
                    hintText: 'productos',
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10)
                ),
              ),
              SizedBox(height: 5.0,),
              Row(
                children: [
                  Checkbox(value: cn, onChanged: (bool? value) => setState(() {
                    cn = value!;
                  })
                  ),
                  Text("Consultoría"),
                  Checkbox(
                      value: dmn,
                      onChanged: (bool? value) => setState(() {
                        dmn = value!;
                      })
                  ),
                  Text("F. de software"),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async => agregar(),
                      child: Text('Aceptar')
                  ),
                  SizedBox(width: 20),
                  Checkbox(value: fsn, onChanged: (bool? value) => setState(() {
                    fsn = value!;
                  })
                  ),
                  Text("D. a la medida"),
                ],
              )
            ]
          ),
        )
    );
  }

  agregar() async{
    Empresa emp = Empresa(
        nombre: c1.text,
        telefono: int.parse(c2.text),
        email: c3.text,
        url: c4.text,
        productos: c5.text,
        categoria: [cn,dmn,fsn]
    );

    if (!mod) {
      await DB.instance.create(emp);
    } else {
      await DB.instance.update(emp);
    }
    setState(() {
      c1.clear();
      c2.clear();
      c3.clear();
      c4.clear();
      c5.clear();

      nuevo = false;
      cn = false;
      dmn = false;
      fsn = false;
      mod = false;
      //empresas = db.retieve(c6.text) as List<Empresa>;
    });
  }

  modificar(Empresa e) async{
    setState(() {
      nuevo = true;
      mod = true;
      c1.text = e.nombre;
      c2.text = e.telefono.toString();
      c3.text = e.email;
      c4.text = e.url;
      c5.text = e.productos;

      cn = e.categoria[0];
      dmn = e.categoria[1];
      fsn = e.categoria[2];
    });

  }

  Widget filtro(){
    return Positioned(
        top: 45,
        child: Container(
        width: 190,
        height: 170,
        alignment: Alignment.centerLeft,
        child: Expanded(
          child: ListView(
            children: [
              ListTile(
                onTap: () => setState(() {
                  c = !c;
                }),
                leading: Checkbox(
                    value: c,
                    onChanged: (bool? value) {
                      setState(() {
                        c = value!;
                      });}),
                title: Text("Consultoría"),
              ),
              ListTile(
                onTap: () => setState(() {
                  dm = !dm;
                }),
                leading: Checkbox(
                    value: dm,
                    onChanged: (bool? value) {
                      setState(() {
                        dm = value!;
                      });
                    }),
                title: Text("Desarrollo a la medida"),
              ),
              ListTile(
                onTap: () => setState(() {
                  dm = !dm;
                }),
                leading: Checkbox(
                    value: fs,
                    onChanged: (bool? value) {
                      setState(() {
                        fs = value!;
                      });
                    }),
                title: Text("Fábrica de software"),
              )
            ],
          ),
        ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey)
          ),
        ));
  }
}
