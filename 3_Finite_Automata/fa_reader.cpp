#include <iostream>
#include <fstream>
#include <string>
#include <set>
#include <map>
#include <sstream>
#include <algorithm>

using namespace std;

set<string> states;
set<char> alphabet;
map<pair<string, char>, string> transitions;
string start_state = "q0";  
set<string> final_states = {"q1", "q2"};  

void loadFA(const string& filename) {
    ifstream file(filename);
    string line;

    if (!file.is_open()) {
        cerr << "Unable to open file\n";
        return;
    }

    while (getline(file, line)) {
        line.erase(0, line.find_first_not_of(" \t"));
        line.erase(line.find_last_not_of(" \t") + 1);

        if (line.substr(0, 7) == "states:") {
            istringstream ss(line.substr(7));
            string state;
            while (getline(ss, state, ',')) {
                state.erase(remove(state.begin(), state.end(), ' '), state.end());
                states.insert(state);
            }
            cout << "Parsed states: ";
            for (const auto& s : states) cout << s << " ";
            cout << endl;

        } else if (line.substr(0, 9) == "alphabet:") {
            istringstream ss(line.substr(9));
            char symbol;
            while (ss >> symbol) {
                if (symbol != ',') alphabet.insert(symbol);
            }
            cout << "Parsed alphabet: ";
            for (const auto& a : alphabet) cout << a << " ";
            cout << endl;

        } else if (line.substr(0, 12) == "transitions:") {
            string from, to, arrow;
            char symbol;
            while (getline(file, line) && !line.empty()) {
                istringstream transition_stream(line);
                transition_stream >> from >> symbol >> arrow >> to;
                if (arrow == "->") {
                    from.erase(remove(from.begin(), from.end(), ','), from.end());
                    transitions[{from, symbol}] = to;
                }
            }
            cout << "Parsed transitions:\n";
            for (const auto& [key, to] : transitions) {
                cout << key.first << " --" << key.second << "--> " << to << "\n";
            }
        }
    }

    file.close();
}

void displayFA() {
    cout << "\nStates: ";
    for (const auto& state : states) cout << state << " ";
    cout << "\nAlphabet: ";
    for (const auto& symbol : alphabet) cout << symbol << " ";
    cout << "\nTransitions:\n";
    for (const auto& [key, to] : transitions) {
        cout << key.first << " --" << key.second << "--> " << to << "\n";
    }
    cout << "Start State: " << start_state << "\nFinal States: ";
    for (const auto& state : final_states) cout << state << " ";
    cout << endl;
}

bool isValidToken(const string& input) {
    string current_state = start_state;
    if (current_state.empty()) {
        cerr << "Error: Start state is not defined.\n";
        return false;
    }

    for (char symbol : input) {
        cout << "Current state: " << current_state << ", Symbol: " << symbol << endl;

        if (transitions.find({current_state, symbol}) == transitions.end()) {
            cout << "No transition found for (" << current_state << ", " << symbol << ")\n";
            return false;
        }
        current_state = transitions[{current_state, symbol}];
    }

    return final_states.find(current_state) != final_states.end();
}

int main() {
    loadFA("FA.in");
    displayFA();

    string input;
    cout << "Enter a string to validate: ";
    getline(cin, input);
    input.erase(remove(input.begin(), input.end(), ' '), input.end());

    if (isValidToken(input)) {
        cout << "The string is a valid token.\n";
    } else {
        cout << "The string is not a valid token.\n";
    }

    return 0;
}
