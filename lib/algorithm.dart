String purchaseDecision(
    List<double> new_data, List<double> existing_data, String species) {
  var protein_percent = new_data[0];
  var fat_percent = new_data[1];
  var moisture_percent = new_data[3];
  var fiber_percent = new_data[2];
  var protein_pass = true;
  var fiber_pass = true;
  var fat_pass = true;

  //convert to dry proportions
  var dry_protein = (protein_percent / moisture_percent) * 10.0;
  var dry_fat = (fat_percent / moisture_percent) * 10.0;
  var dry_fiber = (fiber_percent / moisture_percent) * 10.0;

  if (species.toLowerCase() == "dog") {
    /*
     * for dogs
     */
    print("species: dog");
    if (existing_data == null) {
      print("existing data is null");
      if (dry_protein >= 21 && dry_protein <= 29) {
        protein_pass = true;
        print(protein_pass);
      } else {
        protein_pass = false;
        print(protein_pass);
      }
      if (dry_fiber >= 3 && dry_fiber <= 5) {
        fiber_pass = true;
      } else {
        fiber_pass = false;
      }
      if (dry_fat >= 10 && dry_fat <= 15) {
        fat_pass = true;
      } else {
        fat_pass = false;
      }
    } else {
      if (existing_data[0] >= 21.00 && existing_data[0] <= 29.00) {
        if (dry_protein >= 21.00 && dry_protein <= 29.00) {
          if (existing_data[0] <= dry_protein) {
            protein_pass = true;
          } else {
            protein_pass = false;
          }
        } else {
          protein_pass = false;
        }
      } else {
        if (dry_protein >= 21 && dry_protein <= 29) {
          protein_pass = true;
        } else {
          protein_pass = false;
        }
      }

      if (existing_data[2] >= 3.0 && existing_data[2] <= 5.0) {
        if (dry_fiber >= 3.0 && dry_fiber <= 5.0) {
          if (existing_data[2] <= dry_fiber) {
            fiber_pass = true;
          } else {
            fiber_pass = false;
          }
        } else {
          fiber_pass = false;
        }
      } else {
        print(dry_fiber);
        if (dry_fiber >= 3.0 && dry_fiber <= 5.0) {
          fiber_pass = true;
        } else {
          fiber_pass = false;
        }
      }

      if (existing_data[1] >= 10.0 && existing_data[1] <= 15.0) {
        if (dry_fat >= 10.0 && dry_fat <= 15.0) {
          if (dry_fat >= existing_data[1]) {
            fat_pass = true;
          } else {
            fat_pass = false;
          }
        } else {
          fat_pass = false;
        }
      } else {
        if (dry_fat >= 10.0 && dry_fat <= 15.0) {
          fat_pass = true;
        } else {
          fat_pass = false;
        }
      }
    }
  } else if (species.toLowerCase() == "cat") {
    /*
     * for cats
     */
    //use same fundamental aglorithm for dogs and tweak for cats
    if (existing_data == null) {
      if (dry_fat >= 20.0 && dry_fat <= 24.0) {
        fat_pass = true;
      } else {
        fat_pass = false;
      }
      if (dry_protein >= 25.0 && dry_protein <= 60.0) {
        protein_pass = true;
      } else {
        protein_pass = false;
      }
      if (dry_fiber <= 10.0) {
        fiber_pass = true;
      } else {
        fiber_pass = false;
      }
    } else {
      if (existing_data[1] >= 20.0 && existing_data[1] <= 24.0) {
        if (dry_fat >= 20.0 && dry_fat <= 24.0) {
          if (dry_fat >= existing_data[1]) {
            fat_pass = true;
          } else {
            fat_pass = false;
          }
        } else {
          fat_pass = false;
        }
      } else {
        if (dry_fat >= 20.0 && dry_fat <= 24.0) {
          fat_pass = true;
        } else {
          fat_pass = false;
        }
      }
      if (existing_data[0] >= 25.0 && existing_data[0] <= 60.0) {
        if (dry_protein >= 25.0 && dry_protein <= 60.0) {
          if (dry_protein >= existing_data[0]) {
            protein_pass = true;
          } else {
            protein_pass = false;
          }
        } else {
          protein_pass = false;
        }
      } else {
        if (dry_protein >= 25.0 && dry_protein <= 60.0) {
          protein_pass = true;
        } else {
          protein_pass = false;
        }
      }
      if (existing_data[2] <= 10.0) {
        if (dry_fiber <= 10.0) {
          if (dry_fiber >= existing_data[2]) {
            fiber_pass = true;
          } else {
            fiber_pass = false;
          }
        } else {
          fiber_pass = false;
        }
      } else {
        if (dry_fiber <= 10.0) {
          fiber_pass = true;
        } else {
          fiber_pass = false;
        }
      }
    }
  } else {
    return "invalid species";
  }
  List<bool> evaluation = [protein_pass, fat_pass, fiber_pass];
  print("protein pass: " + protein_pass.toString());
  var result = 0;
  for (int i = 0; i < evaluation.length; i++) {
    print(evaluation[i]);
    if (evaluation[i] == true) {
      result = result + 1;
    } else {
      result = result + 0;
    }
  }
  if (result >= 2) {
    return "Approve";
  } else {
    return "Reject";
  }
}
