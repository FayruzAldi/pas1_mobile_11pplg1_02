import 'package:flutter/material.dart';
import '../models/team_model.dart';

class MovieListTile extends StatelessWidget {
  final TeamModel team;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final IconData? trailingIcon;

  const MovieListTile({
    Key? key,
    required this.team,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(team.logo),
        backgroundColor: Colors.transparent,
      ),
      title: Text(team.name),
      subtitle: Text(team.stadium),
      trailing: IconButton(
        icon: Icon(
          trailingIcon ?? (isFavorite ? Icons.favorite : Icons.favorite_border),
          color: isFavorite ? Colors.red : null,
        ),
        onPressed: onFavoriteToggle,
      ),
      onTap: onTap,
    );
  }
} 