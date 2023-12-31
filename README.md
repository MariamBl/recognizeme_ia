# Application recognizeme_IA - Flutter
## À propos de l'application

Projet Flutter qui se présente sous la forme d'une application mobile dédiée à la gestion d'activités, développée en utilisant les technologies Flutter, TensorFlow et Firebase. Cette application offre aux utilisateurs la possibilité de parcourir une liste complète d'activités, de les filtrer par catégorie, de consulter des informations détaillées sur chaque activité, et même d'ajouter une catégorie en utilisant une fonctionnalité de prédiction basée sur une image importée. De plus, elle a été testée sur la plateforme d'émulation Android afin d'assurer une expérience optimale pour les utilisateurs Android.

## Interfaces
##  Interface de login
L'objectif de l'interface de connexion est de donner aux utilisateurs la possibilité de s'authentifier dans l'application pour accéder à la page suivante. 

![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/25008ba8-6a1d-490c-9427-05bc44d8875a) ![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/82f10a9b-2712-40ab-815a-679fd983dfa3)
##  Liste des activités
En tant qu'utilisateur connecté, mon objectif est de visualiser la liste complète des activités disponibles afin de choisir celles auxquelles je souhaite m'inscrire.

Après la connexion, l'utilisateur est dirigé vers une page qui présente le contenu principal ainsi qu'une barre de navigation inférieure (BottomNavigationBar) contenant trois options avec leurs icônes correspondantes : Activités, Ajouter et Profil.

Sur cette page, une liste déroulante affiche toutes les activités disponibles. Chaque activité affiche des détails essentiels, notamment le titre, le lieu, le prix, une image représentative, ainsi qu'un bouton de suppression.

En sélectionnant une entrée de la liste, les informations détaillées de l'activité sont affichées. Il est important de noter que cette liste d'activités est récupérée directement depuis la base de données

![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/f2987493-bda0-43bb-acf6-da7796c49b01)
##  Détail d’une activité
La page de détail de l'activité présente les éléments suivants : une image représentative de l'activité, le titre de l'activité, la catégorie à laquelle elle appartient (par exemple : Sport, Shopping), le lieu où se déroule l'activité, le nombre minimum de participants requis, le prix associé à l'activité, ainsi qu'un bouton de modification.

![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/c8cc8992-1aca-4b5d-9094-62a081c7b907) ![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/22de834b-6f6f-4744-8218-974ba705634f)
##  Filtrer sur la liste des activités
La page "Activités" est équipée d'une TabBar qui répertorie les diverses catégories d'activités disponibles. Lorsque vous accédez à cette page, l'entrée "all" est automatiquement sélectionnée par défaut, ce qui signifie que toutes les activités sont affichées. Cependant, lorsque vous cliquez sur l'une des entrées de la TabBar, la liste des activités est immédiatement filtrée pour ne montrer que celles qui correspondent à la catégorie que vous avez sélectionnée. Cette fonctionnalité de filtrage simplifie la recherche d'activités spécifiques en les regroupant par catégorie, offrant ainsi une expérience utilisateur plus fluide et intuitive.

![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/b0832783-c27c-4624-ab85-4b73e396f5ee) ![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/01e944d1-c6d5-4607-8b17-afc3e436b061)
##  Profil utilisateur
Au sein de la barre de navigation inférieure (BottomNavigationBar), en sélectionnant l'option "Profil", les informations de l'utilisateur sont instantanément affichées. Ces informations sont récupérées à partir de la base de données de l'application. Les données personnelles de l'utilisateur qui sont présentées comprennent son nom d'utilisateur (login), son mot de passe, sa date de naissance (avec un clavier de sélection de date), son adresse, son code postal (avec un clavier numérique qui n'accepte que les chiffres), ainsi que sa ville.

Pour permettre à l'utilisateur de sauvegarder les données mises à jour, un bouton "Enregistrer" est disponible. Une fois cliqué, il enregistre les modifications dans la base de données.

Si l'utilisateur souhaite se déconnecter de l'application, un bouton "Se déconnecter" est également accessible, permettant un retour facile à la page de connexion. Cette fonctionnalité assure la gestion des informations personnelles de l'utilisateur et offre une expérience utilisateur fluide et sécurisée.

![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/5ec7680f-4750-4e93-be94-f5e444212d7c)
##  Ajouter une nouvelle activité
La barre de navigation inférieure (BottomNavigationBar) propose une option "Ajouter" qui conduit les utilisateurs vers une page dédiée. Lorsque cette option est sélectionnée, un formulaire complet est présenté à l'écran. Ce formulaire comporte plusieurs champs essentiels à remplir, offrant ainsi la possibilité d'inclure une image. De manière pratique, lorsque vous sélectionnez une image, la catégorie de l'activité est automatiquement définie en fonction de celle-ci. Les autres champs du formulaire comprennent la spécification du titre de l'activité, la précision de l'emplacement où elle aura lieu, la détermination du nombre minimum de participants requis, ainsi que la fixation du prix de l'activité.

Pour enregistrer les informations saisies dans la base de données, un bouton "add activity" est mis à disposition. Cette fonctionnalité simplifie le processus d'ajout d'activités et la gestion des données associées, garantissant ainsi aux utilisateurs une expérience conviviale et efficace lors de la création de nouvelles activités.

![image](https://github.com/MariamBl/recognizeme_ia/assets/86015308/a8ffc1e3-20d8-4446-8978-99761e7656f6)

Voici les images pour tester les categories:[
https://drive.google.com/drive/folders/1MGmi2LIdmgbitq7rlEpNqmvKUEZIzeJW?usp=sharing
