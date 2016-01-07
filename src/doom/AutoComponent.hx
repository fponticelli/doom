package doom;

@:autoBuild(doom.macro.AutoComponentBuild.build())
class AutoComponent extends ComponentBase {
  // generate "{CompName}Api" type from metadata vars/functions
  // generate "{CompName}State" type (typedef for @:state or single type for @:onlyState) from metadata vars
  // generate constructor new(api : {CompName}Api, state : {CompName}State, ?children : Nodes)
  //   children arguments should be generated based on @:children(none|opt|req) class-level metadata
  // generate create(req api, { opt api }, req state, { opt state }, ?children)
  //   children arguments should be generated based on @:children(none|opt|req) class-level metadata
  // generate public function update(state : {MyComp}State) {
  // generate public function shouldRender(newState : {MyCompState})
}
