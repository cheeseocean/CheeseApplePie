import 'package:cheese_flutter/common/global.dart';
import 'package:cheese_flutter/models/course.dart';
import 'package:cheese_flutter/provider/providers.dart';
import 'package:flutter/cupertino.dart';

class TimetableModel extends ChangeNotifier{

    List<Course> get courses => Global.timetable;

    bool editMode = false;

    String currentSemester = "大一上";

    void addCourse(Course course){
        if(courses != null && !courses.contains(course)){
            courses.add(course);
            notifyListeners();
        }
    }

    bool removeCourse(Course course){
        bool result = false;
        if(courses != null && courses.contains(course)){
            result = courses.remove(course);
            notifyListeners();
        }
        return result;
    }

    void setEditMode(bool mode){
        if(editMode != mode){
            editMode = mode;
            //不需要保存状态
            super.notifyListeners();
        }
    }

    void setCurrentSemester(String semester){
        if(currentSemester != semester){
            currentSemester = semester;
            notifyListeners();
        }
    }
    @override
    void notifyListeners() {
        Global.saveTimetable();
        Global.saveCurrentSemester();//保存Timetable变更
        super.notifyListeners(); //通知依赖的Widget更新
    }
}