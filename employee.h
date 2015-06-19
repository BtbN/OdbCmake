// file      : hello/employee.hxx
// copyright : not copyrighted - public domain

#ifndef EMPLOYEE_HXX
#define EMPLOYEE_HXX


#include <string>
#include <cstddef> // std::size_t

#include <odb/core.hxx>

#pragma db object
class employee
{
public:
  std::string position() const { return position_; }
  unsigned short experience() const { return experience_; }  

private:
  friend class odb::access;

  employee () {}

  #pragma db id auto
  unsigned long id_;

  std::string position_;
  unsigned short experience_;
};

#endif // EMPLOYEE_HXX
